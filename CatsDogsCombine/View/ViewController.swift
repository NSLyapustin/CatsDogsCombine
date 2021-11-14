//
//  ViewController.swift
//  CatsDogsCombine
//
//  Created by Никита Ляпустин on 09.11.2021.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

class ViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Constants {
        enum SegmentedControl {
            static let topInset: CGFloat = 27
            static let width: CGFloat = 196
        }
        
        enum ContentView {
            static let topInset: CGFloat = 41
            static let leadingTrailingInset: CGFloat = 18
            static let height: CGFloat = 204.37
        }
        
        enum ContentImageView {
            static let cornerRadius: CGFloat = 10
        }
        
        enum ContentLabel {
            static let leadingTrailingInset: CGFloat = 8
        }
        
        enum MoreButton {
            static let cornerRadius: CGFloat = 20
            static let topInset: CGFloat = 12.63
            static let width: CGFloat = 144
            static let height: CGFloat = 40
        }
        
        enum ScoreLabel {
            static let topInset: CGFloat = 19
            static let height: CGFloat = 46
            static let leadingTrailingInset: CGFloat = 30
        }
    }

    // MARK: - Instance Properties
    
    // MARK: -
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ViewModel()
    private var isCatsChoosen: Bool {
        get {
            return segmentedControl.selectedSegmentIndex == 0
        }
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Cats", "Dogs"])
        segmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.ContentImageView.cornerRadius
        
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 138 / 255, alpha: 1)
        button.addTarget(self, action: #selector(onMoreButtonTouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        setupSubscribers()
        setupInitialState()
        setupResetButton()
    }
    
    // MARK: - Instance Methods
    
    // MARK: -
    
    private func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(contentView)
        contentView.addSubview(contentImageView)
        contentView.addSubview(contentLabel)
        view.addSubview(moreButton)
        view.addSubview(scoreLabel)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.SegmentedControl.topInset)
            make.width.equalTo(Constants.SegmentedControl.width)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(Constants.ContentView.topInset)
            make.trailing.leading.equalToSuperview().inset(Constants.ContentView.leadingTrailingInset)
            make.height.equalTo(Constants.ContentView.height)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.ContentLabel.leadingTrailingInset)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(Constants.MoreButton.topInset)
            make.width.equalTo(Constants.MoreButton.width)
            make.height.equalTo(Constants.MoreButton.height)
            make.centerX.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(Constants.ScoreLabel.topInset)
            make.leading.trailing.equalToSuperview().inset(Constants.ScoreLabel.leadingTrailingInset)
            make.height.equalTo(Constants.ScoreLabel.height)
        }
    }
    
    private func setupSubscribers() {
        setupSegmentedControlIndexSubscriber()
        setupCatSubscribers()
        setupDogSubscribers()
        setupScoreSubscribers()
    }
    
    private func setupResetButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(onResetButtonTouchUpInside))
    }
    
    private func setupScoreSubscribers() {
        cancellables.insert(viewModel.$catsScore
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] catsScore in
            guard let self = self else {
                return
            }
            self.scoreLabel.text = "Score: \(catsScore) cats and \(self.viewModel.dogsScore) dogs"
        }))
        
        cancellables.insert(viewModel.$dogsScore
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] dogsScore in
            guard let self = self else {
                return
            }
            self.scoreLabel.text = "Score: \(self.viewModel.catsScore) cats and \(dogsScore) dogs"
        }))
    }
    
    private func setupCatSubscribers() {
        cancellables.insert(viewModel.$cat
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] cat in
            guard let self = self else {
                return
            }
            self.contentLabel.text = cat?.fact
        }))
    }
    
    private func setupDogSubscribers() {
        cancellables.insert(viewModel.$dog
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] dog in
            guard let self = self else {
                return
            }
            self.contentImageView.kf.setImage(with: URL(string: dog?.message ?? ""))
        }))
    }
    
    private func setupSegmentedControlIndexSubscriber() {
        cancellables.insert(viewModel.$segmentedControlIndex
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] index in
            guard let self = self else {
                return
            }
            switch index {
            case 0:
                self.contentImageView.isHidden = true
                self.contentLabel.isHidden = false
                self.fetchCatFact()
                
            case 1:
                self.contentImageView.isHidden = false
                self.contentLabel.isHidden = true
                self.fetchDogImage()
                
            default:
                break
            }
        }))
    }
    
    private func setupInitialState() {
        segmentedControl.selectedSegmentIndex = 0
        view.backgroundColor = .systemBackground
        title = "Cats and dogs"
    }
    
    private func fetchCatFact() {
        viewModel.fetchCatFact()
    }
    
    private func fetchDogImage() {
        viewModel.fetchDogImage()
    }
    
    @objc private func onSegmentedControlValueChanged() {
        viewModel.segmentedControlIndex = segmentedControl.selectedSegmentIndex
    }
    
    @objc private func onMoreButtonTouchUpInside() {
        if isCatsChoosen {
            fetchCatFact()
        } else {
            fetchDogImage()
        }
    }
    
    @objc private func onResetButtonTouchUpInside() {
        viewModel.dogsScore = 0
        viewModel.catsScore = 0
        contentLabel.text = ""
        contentImageView.image = nil
    }
}


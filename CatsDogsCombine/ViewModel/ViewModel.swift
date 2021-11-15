//
//  ViewModel.swift
//  CatsDogsCombine
//
//  Created by Никита Ляпустин on 09.11.2021.
//

import Combine
import Foundation

class ViewModel {
    
    // MARK: - Instance Properties
    
    @Published var cat: Cat?
    @Published var dog: Dog?
    @Published var catsScore: Int = 0
    @Published var dogsScore: Int = 0
    @Published var segmentedControlIndex = 0
    
    // MARK: -
    
    private var cancellableSet = Set<AnyCancellable>()
    private let animalsService = AnimalService()
    
    // MARK: - Instance Methods
    
    public func fetchCatFact() {
        cancellableSet.insert(animalsService.catPublisher
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.catsScore += 1
        },
                                      receiveValue: { [weak self] cat in
            guard let self = self else {
                return
            }
            self.cat = cat
        }))
    }

    public func fetchDogImage() {
        cancellableSet.insert(animalsService.dogPublisher
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.dogsScore += 1
        },
                                      receiveValue: { [weak self] dog in
            guard let self = self else {
                return
            }
            self.dog = dog
        }))
    }
}

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
    @Published var catsScore: Int = 0
    @Published var segmentedControlIndex = 0
    
    // MARK: -
    
    private var cancellableSet = Set<AnyCancellable>()
    private let animalsService = AnimalService()
    
    // MARK: - Instance Methods
    
    public func fetchCatFact() {
        cancellableSet.insert(animalsService.catPublisher
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { _ in
            self.catsScore += 1
        },
                                      receiveValue: { cat in
            self.cat = cat
        }))
    }
}

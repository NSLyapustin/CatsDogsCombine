//
//  AnimalService.swift
//  CatsDogsCombine
//
//  Created by Никита Ляпустин on 09.11.2021.
//

import Combine
import Foundation

class AnimalService {
    
    // MARK: - Nested Types
    
    private enum Endpoint: String {
        case catsEndpoint = "https://catfact.ninja/fact"
    }
    
    // Public Properties
    
    var catPublisher: AnyPublisher<Cat, Error> {
        let url = URL(string: Endpoint.catsEndpoint.rawValue)!

        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { $0.data }
            .decode(type: Cat.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

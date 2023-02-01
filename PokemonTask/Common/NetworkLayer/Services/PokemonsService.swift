//
//  PokemonsService.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

protocol PokemonsServiceType {
    func getPokemonsList(nextPage: String?, completion: @escaping (Result<(pokemons: [PokemonModel], nextPage: String?), APIError>) -> Void)
    func getPokemonImage(baseUrl: String, completion: @escaping (Result<UIImage, APIError>) -> Void)
    func getPokemonDescription(pokemon: PokemonModel, completion: @escaping (Result<PokemonSpeciesResponse, APIError>) -> Void)
}

final class PokemonsService: PokemonsServiceType {

    private let loader = Loader()
    private let group = DispatchGroup()
    
    func getPokemonsList(nextPage: String?, completion: @escaping (Result<(pokemons: [PokemonModel],nextPage: String?), APIError>) -> Void) {
        var pokemons = [PokemonResponse]()
        let router = PokemonRouter.getPokemonsList(nextPage: nextPage)
        let mapper = DecodableResponseMapper<PokemonListResponse>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { [weak self] result in
            switch result {
            case .success(let response):
                let urls = response.results?.map { $0.url }
                urls?.forEach {
                    self?.group.enter()
                    let router = PokemonRouter.getPokemonField(baseUrl: $0)
                    let mapper = DecodableResponseMapper<PokemonResponse>()
                    self?.loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
                        switch result {
                        case .success(let response):
                            pokemons.append(response)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                        self?.group.leave()
                    }
                }
                self?.group.notify(queue: .main) {
                    completion(.success(((pokemons.map { PokemonModel(id: $0.id, name: $0.name, weight: $0.weight, height: $0.height, imageURL: $0.sprites.imageURL, speciesURL: $0.species.url, description: nil) }), response.next)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPokemonImage(baseUrl: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        let router = PokemonRouter.getPokemonField(baseUrl: baseUrl)
        let mapper = ImageResponseMapper()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func getPokemonDescription(pokemon: PokemonModel, completion: @escaping (Result<PokemonSpeciesResponse, APIError>) -> Void) {
        guard let url = pokemon.speciesURL else { return }
        let router = PokemonRouter.getPokemonField(baseUrl: url)
        let mapper = DecodableResponseMapper<PokemonSpeciesResponse>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}


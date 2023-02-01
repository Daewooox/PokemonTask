//
//  PokemonResponse.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation

struct PokemonResponse: Decodable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let sprites: Sprite
    let species: Species
    
    struct Sprite: Decodable {
        let imageURL: String

        enum CodingKeys: String, CodingKey {
            case imageURL = "front_default"
        }
    }
    
    struct Species: Decodable {
        let url: String
    }
}

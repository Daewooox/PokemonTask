//
//  PokemonModel.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation

struct PokemonListResponse: Decodable {
    let next: String?
    let results: [PokemonListResponseItem]?
}

struct PokemonListResponseItem: Decodable {
    let name: String
    let url: String
}

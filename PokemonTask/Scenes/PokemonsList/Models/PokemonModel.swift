//
//  PokemonModel.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation

struct PokemonModel: Hashable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let imageURL: String?
    let speciesURL: String?
    let description: String?
    
}

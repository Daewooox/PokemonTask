//
//  ApiURL.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

enum APIUrl {
    case baseUrl

    var url: String {
        switch self {
        case .baseUrl:
            return "https://pokeapi.co/api/v2"
        }
    }
}


//
//  PokemonSpeciesResponse.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation

struct PokemonSpeciesResponse: Decodable {
    let flavorEntries: [Entries]
    
    enum CodingKeys: String, CodingKey {
        case flavorEntries = "flavor_text_entries"
    }
    
    struct Entries: Decodable {
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case description = "flavor_text"
        }
    }
}

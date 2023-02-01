//
//  ServerErrorHandlerType.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

protocol ServerErrorHandlerType {
    func handleErrorFrom(response: Data, statusCode: Int) -> APIError
}


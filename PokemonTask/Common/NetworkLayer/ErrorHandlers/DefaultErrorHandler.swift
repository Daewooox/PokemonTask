//
//  DefaultErrorHandler.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

final class DefaultErrorHandler: ServerErrorHandlerType {
    func handleErrorFrom(response: Data, statusCode: Int) -> APIError {
        return .server(details: "Uncategorized Error")
    }
}


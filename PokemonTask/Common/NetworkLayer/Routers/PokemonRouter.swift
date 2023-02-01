//
//  PokemonRouter.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

enum PokemonRouter {
    case getPokemonsList(nextPage: String?)
    case getPokemonField(baseUrl: String)
}

extension PokemonRouter: BaseRouter {
    var body: Codable? {
        nil
    }

    var requestManager: RequestManagerType {
        URLSessionRequestManager()
    }

    var baseUrl: String {
        switch self {
        case .getPokemonsList(let nextPage):
            return nextPage != nil ? nextPage! : APIUrl.baseUrl.url
        case .getPokemonField(let baseUrl):
            return baseUrl
        }
    }

    var requestPath: String {
        switch self {
        case .getPokemonsList(let nextPage):
            return nextPage != nil ? "" : "/pokemon"
        case .getPokemonField:
            return ""
        }
    }

    var queryParameters: [String: String] {
        switch self {
        default:
            return [:]
        }
    }

    var requestMethod: HTTPMethod {
        .get
    }
}

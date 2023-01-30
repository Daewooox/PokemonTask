//
//  BaseRouter.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol BaseRouter {
    var baseUrl: String { get }
    var requestPath: String { get }
    var requestMethod: HTTPMethod { get }
    var requestHeaders: [String: String] { get }
    var body: Codable? { get }
    var requestManager: RequestManagerType { get }
    var queryParams: [String: String] { get }
}

extension BaseRouter {
    var requestHeaders: [String: String] {
        let header = [ "Content-Type" : "application/json", "Accept" : "application/json"]
        return header
    }
    
    var asURLRequest: URLRequest {
//        var queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value)}
        var urlComponets = URL(string: baseUrl + requestPath)
        var request
    }
}



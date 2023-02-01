//
//  BaseRouter.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation
protocol BaseRouter {
    var baseUrl: String { get }
    var requestPath: String { get }
    var requestMethod: HTTPMethod { get }
    var requestHeaders: [String: String]? { get }
    var body: Codable? { get }
    var requestManager: RequestManagerType { get }
    var queryParameters: [String: String] { get }
}

extension BaseRouter {
    var requestHeaders: [String: String]? {
        let header =       [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return header
    }
}

extension BaseRouter {

    var asURLRequest: URLRequest {
        let queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = URLComponents(string: baseUrl + requestPath)
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = requestMethod.rawValue
        if  let body = body,
            let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.httpBody = httpBody
        }
        requestHeaders?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
}

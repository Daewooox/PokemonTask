//
//  NetworkClient.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

typealias NetworkClientResult = Swift.Result<Data, ApiError>
typealias NetworkClientCompletion = ((NetworkClientResult) -> Void)

protocol NetworkClientType {
    func performRequest<T: BaseRouter>(_ request: T, completion: NetworkClientCompletion?)
}

protocol RequestManagerType {
    func performRequest<T: BaseRouter>(request: T, completion: @escaping (ResponseResultModel) -> Void)
}

protocol ServerErrorHandlerType {
    func handleErrorFrom(response: Data, statusCode: Int) -> ApiError
}

final class NetworkClient: NetworkClientType {
    
    private let serverErrorHandler: ServerErrorHandlerType
    private var requestManager: RequestManagerType
    
    init(serverErrorHandler: ServerErrorHandlerType, requestManager: RequestManagerType) {
        self.serverErrorHandler = serverErrorHandler
        self.requestManager = requestManager
    }
    
    func performRequest<T>(_ request: T, completion: NetworkClientCompletion?) {
        requestManager.performRequest(request: request) { (response) in
            completion?(self.handleError(response))
        }
        
    }
    
   
}

private extension NetworkClient {
    func handleError(_ response: ResponseResultModel) -> NetworkClientResult {
        let statusCode = response.response?.statusCode
        switch (response.responseData, response.error, statusCode) {
        case (let data?, nil, statusCode?) where (400...500).contains(statusCode!):
            let handleError = serverErrorHandler.handleErrorFrom(response: data, statusCode: statusCode!)
            return .failure(handleError)
        case (let data?, nil, _):
            return .success(data)
        default:
            return .failure(ApiError.network(details: "network problems"))
        }
    }
}

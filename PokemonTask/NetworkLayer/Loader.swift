//
//  Loader.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

typealias ResponseMapperCompletion<T> = (Swift.Result<T, ApiError>) -> Void

protocol ResponseMapperType {
    associatedtype ResponseResult
    
    func mapResponse(_ dataResponse: Data, completion: @escaping ResponseMapperCompletion<ResponseResult>)
}

enum ApiError: CustomStringConvertible, CustomDebugStringConvertible, Error {
    case server(details: String)
    case network(details: String)
    case unkwon
    
    var description: String {
        switch self {
        default:
            return "Some error happened"
        }
    }
    
    var debugDescription: String { description }
}


final class Loader {
    typealias LoaderResult<Mapper: ResponseMapperType> = Swift.Result<Mapper.ResponseResult, ApiError>
    typealias LoaderResultCompletion<Mapper: ResponseMapperType> = (LoaderResult<Mapper>) -> Void
    
    func performRequest<Request: BaseRouter,
                        Mapper: ResponseMapperType
                            ErrorHandler: ServerErrorHandlerType>(request: Request, mapper: Mapper, errorHandler: ErrorHandler, completion: @escaping LoaderResultCompletion<Mapper>) {
        
        Network(errorHandler: errorHandler, requestManager: request.requestManager)
        
    }
}

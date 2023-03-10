//
//  ResponseMapperType.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

typealias ResponseMapperCompletion<T> = (Swift.Result<T, APIError>) -> Void

protocol ResponseMapperType {
    associatedtype ResponseResult

    func mapResponse(_ dataResponse: Data, completion: @escaping ResponseMapperCompletion<ResponseResult>)
}


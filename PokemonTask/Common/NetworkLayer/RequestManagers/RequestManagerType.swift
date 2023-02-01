//
//  RequestManagerType.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

protocol RequestManagerType {
    func performRequest<T: BaseRouter>(request: T, completion: @escaping (ResponseResultModel) -> Void )
}

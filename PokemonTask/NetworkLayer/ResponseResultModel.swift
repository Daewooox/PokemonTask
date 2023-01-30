//
//  ResponseResultModel.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation

struct ResponseResultModel {
    let responseData: Data?
    let response: HTTPURLResponse?
    let error: Error?
}

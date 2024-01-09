//
//  FBError.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import Foundation

// MARK: Initialization

enum FBError: Error {
    enum MapperError: Error {
        case decoding(underlayingError: Error)
    }

    case parsing(underlayingError: MapperError)
    case network(underlayingError: Error)
    case unknown(underlayingError: Error)
}

// MARK: LocalizedError

extension FBError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .parsing(underlayingError: underlayingError):
            return underlayingError.localizedDescription
        case let .network(underlayingError: underlayingError):
            return underlayingError.localizedDescription
        case let .unknown(underlayingError: underlayingError):
            return underlayingError.localizedDescription
        }
    }
}

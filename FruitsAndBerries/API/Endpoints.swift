//
//  Endpoints.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import Foundation

struct Endpoint {
    let path: String
}

// MARK: Available Endpoints

extension Endpoint {
    static func random() -> Self {
        Endpoint(
            path: "/items/random"
        )
    }

    static func detailsInfo(itemId: String) -> Self {
        Endpoint(
            path: "/texts/\(itemId)"
        )
    }
    
    static func image(imageUrl: URL) -> Self {
        Endpoint(
            path: "\(imageUrl)"
        )
    }
}

// MARK: Factory Methods

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "test-task-server.mediolanum.f17y.com"
        components.path = path
        return components.url
    }
}

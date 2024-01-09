//
//  HTTPClient.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import Foundation

protocol HTTPClientTask {
    func resume()
}

protocol HTTPClient {
    typealias ClientResult = Result<(Data, HTTPURLResponse), Error>
    typealias CompletionHandler = (ClientResult) -> Void

    @discardableResult
    func fetch(from url: URL, completion: @escaping CompletionHandler) -> HTTPClientTask
}


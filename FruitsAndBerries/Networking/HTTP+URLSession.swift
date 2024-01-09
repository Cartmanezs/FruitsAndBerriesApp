//
//  HTTP+URLSession.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import Foundation

final class URLSessionHTTPClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
}

// MARK: URLSessionHTTPClient

extension URLSessionHTTPClient: HTTPClient {
    private struct URLSessionDataTaskWrapper: HTTPClientTask {
   
        let underlayingSessionDataTask: URLSessionDataTask

        func resume() {
            underlayingSessionDataTask.resume()
        }
    }

    /// - Parameter completion:
    /// The completion handler to call when the insert request is complete.
    /// This  handler is executed on the background queue.
    func fetch(from url: URL, completion: @escaping CompletionHandler) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else if let error {
                completion(.failure(error))
            } else {
                completion(.failure(FBError.unknown(underlayingError: "Unknown error" as! Error)))
            }
        }
        task.resume()
        return URLSessionDataTaskWrapper(underlayingSessionDataTask: task)
    }
}

//
//  FruitsAndBerrieRepository.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import Foundation
import UIKit

protocol FruitsFetchRepository {
    func fetchRandom(completion: @escaping (Result<FruitsAndBerriesModels.Load.Response, FBError>) -> Void)
    func fetchDetailsInfo(itemId: String, completion: @escaping (Result<FruitsAndBerriesModels.LoadDetails.Response, FBError>) -> Void)
}

// MARK: Initialization

class FruitsAndBerrieRepository: FruitsFetchRepository {
    private let httpClient: HTTPClient
    
    required init() {
        let session = URLSession(configuration: .default)
        self.httpClient = URLSessionHTTPClient(session: session)
    }
}

// MARK: Private Methods

private extension FruitsAndBerrieRepository {
    func fetch<T>(with endpoint: Endpoint, completion: @escaping (Result<T, FBError>) -> Void) where T: Decodable {
        guard let url = endpoint.url else {
            completion(.failure(FBError.network(underlayingError: "Unable to construct a valid URL for given endpoint: \(endpoint)" as! Error)))
            return
        }
        let task = httpClient.fetch(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success((let data, _)):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(FBError.parsing(underlayingError: FBError.MapperError.decoding(underlayingError: error))))
                    }
                    
                case .failure(let error):
                    completion(.failure(FBError.network(underlayingError: error)))
                }
            }
        }
        task.resume()
    }
}

// MARK: Internal Methods

extension FruitsAndBerrieRepository {
    func fetchRandom(completion: @escaping (Result<FruitsAndBerriesModels.Load.Response, FBError>) -> Void) {
        fetch(with: .random(), completion: completion)
    }
    
    func fetchDetailsInfo(itemId: String, completion: @escaping (Result<FruitsAndBerriesModels.LoadDetails.Response, FBError>) -> Void) {
        fetch(with: .detailsInfo(itemId: itemId), completion: completion)
    }
}

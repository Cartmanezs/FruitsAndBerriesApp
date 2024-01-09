//
//  FruitsAndBerriesInteractor.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//
import Foundation
import UIKit

protocol FruitsAndBerriesBusinessLogic {
    func loadList()
    func loadDetails(request: FruitsAndBerriesModels.LoadDetails.Request)
}

class FruitsAndBerriesInteractor {
    
    var presenter: FruitsAndBerriesPresentationLogic?
    var presenterDetails: FruitsAndBerriesDetailsPresentationLogic?
    
    private let fruitsBerriesRepository: FruitsFetchRepository
    
    init(fruitsBerriesRepository: FruitsFetchRepository) {
        self.fruitsBerriesRepository = fruitsBerriesRepository
    }

    private func fetchData() {
        fruitsBerriesRepository.fetchRandom { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsResponse):
                self.presenter?.present(response: itemsResponse)
            case .failure(let error):
                self.presenter?.presentError(with: error.failureReason ?? "Error with decoding")
            }
        }
    }
    
    private func fetchDetails(for itemId: String) {
        fruitsBerriesRepository.fetchDetailsInfo(itemId: itemId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detailsResponse):
                self.presenterDetails?.presentDetails(response: detailsResponse)
            case .failure(let error):
                print("Error fetching details: \(error)")
                self.presenterDetails?.presentError(with: error.failureReason ?? "Error with decoding")
            }
        }
    }
}

extension FruitsAndBerriesInteractor: FruitsAndBerriesBusinessLogic {
    func loadList() {
        fetchData()
    }
    
    func loadDetails(request: FruitsAndBerriesModels.LoadDetails.Request) {
        fetchDetails(for: request.itemId)
    }
}

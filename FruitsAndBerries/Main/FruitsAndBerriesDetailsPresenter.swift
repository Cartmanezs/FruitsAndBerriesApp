//
//  FruitsAndBerriesDetailsPresenter.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 08.01.2024.
//

import Foundation

protocol FruitsAndBerriesDetailsPresentationLogic {
    func presentError(with errorInfo: String)
    func presentDetails(response: FruitsAndBerriesModels.LoadDetails.Response)
}

class FruitsAndBerriesDetailsPresenter {
    weak var view: FruitsAndBerriesDetailsDisplayLogic?
}

extension FruitsAndBerriesDetailsPresenter: FruitsAndBerriesDetailsPresentationLogic {
    func presentError(with errorInfo: String) {
        view?.displayError(with: errorInfo)
    }
    
    func presentDetails(response: FruitsAndBerriesModels.LoadDetails.Response) {
        let viewModel = FruitsAndBerriesModels.LoadDetails.DetailViewModel(text: response.text)
        view?.displayDetails(model: viewModel)
    }
}

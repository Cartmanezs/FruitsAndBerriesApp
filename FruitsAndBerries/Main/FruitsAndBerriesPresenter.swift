//
//  FruitsAndBerriesPresenter.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//

import UIKit

protocol FruitsAndBerriesPresentationLogic {
    func present(response: FruitsAndBerriesModels.Load.Response)
    func presentError(with errorInfo: String)
}

class FruitsAndBerriesPresenter {
    weak var view: FruitsAndBerriesDisplayLogic?
}

extension FruitsAndBerriesPresenter: FruitsAndBerriesPresentationLogic {
    func present(response: FruitsAndBerriesModels.Load.Response) {
        let itemsViewModels = response.items.compactMap { item in
            return FruitsAndBerriesModels.Load.ViewModel.FruitsAndBerriesViewModelItem(
                id: item.id,
                name: item.name,
                imageURL: item.image,
                color: item.color
            )
        }

        let viewModel = FruitsAndBerriesModels.Load.ViewModel(title: response.title, items: itemsViewModels)
        view?.display(viewModel: viewModel)
    }
    
    func presentError(with errorInfo: String) {
        view?.displayError(with: errorInfo)
    }
}

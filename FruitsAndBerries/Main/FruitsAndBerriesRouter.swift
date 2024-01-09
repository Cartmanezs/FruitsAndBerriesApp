//
//  FruitsAndBerriesRouter.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//

import Foundation
import UIKit

final class FruitsAndBerriesRouter {
    weak var controller: FruitsAndBerriesViewController?
}

extension FruitsAndBerriesRouter {
    // 2 Screens should both be a part of the same module
    static func createModule() -> FruitsAndBerriesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FruitsAndBerriesViewController") as! FruitsAndBerriesViewController
        let detailsController = FruitsAndBerriesDetailsViewController()
        let fruitsBerriesRepository = FruitsAndBerrieRepository()
        let interactor = FruitsAndBerriesInteractor(fruitsBerriesRepository: fruitsBerriesRepository)
        let presenter = FruitsAndBerriesPresenter()
        let presenterDetails = FruitsAndBerriesDetailsPresenter()
               
        interactor.presenter = presenter
        interactor.presenterDetails = presenterDetails
        
        controller.interactor = interactor
        detailsController.interactor = interactor
        
        presenter.view = controller
        presenterDetails.view = detailsController

        controller.detailsController = detailsController
        
        return controller
    }
}

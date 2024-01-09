//
//  AlertUtils.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 08.01.2024.
//

import UIKit

struct AlertUtils {
    static func showErrorAlert(with errorInfo: String, retryAction: @escaping () -> Void,  in viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {_ in
            retryAction()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

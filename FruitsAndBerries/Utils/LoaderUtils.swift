//
//  LoaderUtils.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 04.01.2024.
//

import UIKit

struct LoaderUtils {
    
    private static var loaderImageView: UIImageView?

    static private func createLoaderImageView() -> UIImageView {
        let loaderImageView = UIImageView(image: UIImage(named: "loader"))
        loaderImageView.contentMode = .scaleAspectFit
        loaderImageView.isHidden = true
        return loaderImageView
    }

    static private func setupLoaderConstraints(in view: UIView) {
        guard let loaderImageView = loaderImageView else { return }
        loaderImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loaderImageView.widthAnchor.constraint(equalToConstant: 50),
            loaderImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    static func showLoader(in view: UIView) {
        if loaderImageView == nil {
            loaderImageView = createLoaderImageView()
            if let loaderImageView = loaderImageView {
                view.addSubview(loaderImageView)
                setupLoaderConstraints(in: view)
            }
        }

        loaderImageView?.isHidden = false

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        loaderImageView?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    static func hideLoader() {
        guard let loaderImageView = loaderImageView else { return }
        loaderImageView.isHidden = true
        loaderImageView.layer.removeAnimation(forKey: "rotationAnimation")
        self.loaderImageView = nil
    }
}


//
//  FruitsAndBerriesDetailsViewController.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//

import UIKit
import SDWebImage

protocol FruitsAndBerriesDetailsDisplayLogic: AnyObject {
    func displayError(with errorInfo: String)
    func displayDetails(model: FruitsAndBerriesModels.LoadDetails.DetailViewModel)
}

final class FruitsAndBerriesDetailsViewController: UIViewController {
    
    // MARK: - Properties

    var selectedItem: FruitsAndBerriesModels.Load.ViewModel.FruitsAndBerriesViewModelItem?
    var interactor: FruitsAndBerriesBusinessLogic?

    private var coloredViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    
    private let coloredView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDetails()
        setupUI()
    }
}

private extension FruitsAndBerriesDetailsViewController {
    
    // MARK: - UI Setup
    
    func setupUI() {
        guard let selectedItem = selectedItem else { return }
        coloredView.isHidden = true
        self.navigationItem.title = selectedItem.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        setupImage(with: selectedItem.imageURL)
        view.addSubview(coloredView)
        view.backgroundColor = .white
        coloredView.addSubview(itemImageView)
        coloredView.addSubview(nameLabel)
        coloredView.backgroundColor = UIColor(hexString: selectedItem.color)

        setupConstraints()
    }
    
    func setupImage(with imageURL: URL?) {
        if let imageURL = imageURL {
            let url = Endpoint.image(imageUrl: imageURL).url
            self.itemImageView.sd_setImage(with: url)
        } else {
            self.itemImageView.image = UIImage(named: "placeholder")
        }
    }
    
    func setupConstraints() {
        coloredViewHeightConstraint = coloredView.heightAnchor.constraint(equalToConstant: 250)
        coloredViewHeightConstraint?.isActive = true
        
        coloredView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coloredView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            coloredView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coloredView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            coloredView.heightAnchor.constraint(equalToConstant: 250),
            
            itemImageView.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 5),
            itemImageView.widthAnchor.constraint(equalToConstant: 120),
            itemImageView.heightAnchor.constraint(equalToConstant: 120),
            itemImageView.centerXAnchor.constraint(equalTo: coloredView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -20),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: coloredView.widthAnchor, constant: -40)
          ])
    }
    
    // MARK: - Fetch Details
    
    func fetchDetails() {
        LoaderUtils.showLoader(in: view)
        itemImageView.image = nil
        guard let itemId = selectedItem?.id else {
            LoaderUtils.hideLoader()
            return
        }
        interactor?.loadDetails(request: .init(itemId: itemId))
    }
}

    // MARK: - FruitsAndBerriesDetailsDisplayLogic

extension FruitsAndBerriesDetailsViewController: FruitsAndBerriesDetailsDisplayLogic {
    func displayError(with errorInfo: String) {
        AlertUtils.showErrorAlert(with: errorInfo, retryAction: self.fetchDetails, in: self)
    }
    
    func displayDetails(model: FruitsAndBerriesModels.LoadDetails.DetailViewModel) {
        DispatchQueue.main.async {
            self.nameLabel.text = model.text
            let contentHeight = self.nameLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 160
            let newColoredViewHeight = max(min(contentHeight, 500), 100)
            self.coloredViewHeightConstraint?.constant = newColoredViewHeight
            UIView.transition(with: self.coloredView, duration: 0.6, options: .transitionCrossDissolve, animations: {
                self.coloredView.isHidden = false
            }, completion: { _ in
                LoaderUtils.hideLoader()
            })
        }
    }
}

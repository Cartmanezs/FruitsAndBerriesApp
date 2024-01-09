//
//  FruitsAndBerriesViewController.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//
// FruitsAndBerriesViewController.swift

import UIKit

protocol FruitsAndBerriesDisplayLogic: AnyObject {
    func display(viewModel: FruitsAndBerriesModels.Load.ViewModel)
    func displayError(with errorInfo: String)
}

final class FruitsAndBerriesViewController: UIViewController {
    
    // MARK: - Properties
    
    var interactor: FruitsAndBerriesBusinessLogic?
    var detailsController: FruitsAndBerriesDetailsViewController?
    
    private var displayedItems: [FruitsAndBerriesModels.Load.ViewModel.FruitsAndBerriesViewModelItem] = []
    
    private lazy var mainTable: UITableView = {
        let tableView = UITableView()
        tableView.register(FruitsAndBerriesItemCell.self, forCellReuseIdentifier: FruitsAndBerriesItemCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if displayedItems.isEmpty {
            self.fetchData()
        }
    }
}

// MARK: - UI Setup

private extension FruitsAndBerriesViewController {
    
    func setupUI() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh_button"), style: .plain, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton
        view.addSubview(mainTable)
        setupConstraints()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let appColor = UIColor(#colorLiteral(red: 0.9219822288, green: 0.2350081801, blue: 0.6570042372, alpha: 1))
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = appColor
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTable.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            mainTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func fetchData() {
        LoaderUtils.showLoader(in: view)
        interactor?.loadList()
    }
    
    @objc func refreshButtonTapped() {
        mainTable.alpha = 0
        fetchData()
    }
    
    func animateCellsAppearance() {
        let cells = self.mainTable.visibleCells

        for cell in cells {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: -50)
        }

        UIView.animate(withDuration: 0.6, delay: 0, options: .transitionCurlDown, animations: {
            for cell in cells {
                cell.alpha = 1
                cell.transform = CGAffineTransform.identity
            }
        })
    }
}

// MARK: - FruitsAndBerriesDisplayLogic

extension FruitsAndBerriesViewController: FruitsAndBerriesDisplayLogic {
    func display(viewModel: FruitsAndBerriesModels.Load.ViewModel) {
        DispatchQueue.main.async {
            self.displayedItems = viewModel.items
            self.navigationItem.title = viewModel.title
            self.mainTable.alpha = 1
            LoaderUtils.hideLoader()
            self.mainTable.reloadData()
            self.animateCellsAppearance()
        }
    }

    func displayError(with errorInfo: String) {
        AlertUtils.showErrorAlert(with: errorInfo, retryAction: self.fetchData, in: self)
    }
}

// MARK: - UITableViewDelegate

extension FruitsAndBerriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = displayedItems[indexPath.row]
        if let detailsController = detailsController {
            detailsController.selectedItem = item
            navigationController?.pushViewController(detailsController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UITableViewDataSource

extension FruitsAndBerriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FruitsAndBerriesItemCell.identifier, for: indexPath) as? FruitsAndBerriesItemCell else {
            return UITableViewCell()
        }
        
        let item = displayedItems[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

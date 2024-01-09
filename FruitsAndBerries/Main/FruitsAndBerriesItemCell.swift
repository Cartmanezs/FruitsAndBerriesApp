//
//  FruitsAndBerriesItemCell.swift
//  FruitsAndBerries
//
//  Created by Igor Palyvoda on 03.01.2024.
//

import UIKit
import SDWebImage

final class FruitsAndBerriesItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FruitsAndBerriesItemCell"
    
    private let coloredView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(coloredView)
        coloredView.addSubview(nameLabel)
        coloredView.addSubview(itemImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        coloredView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coloredView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coloredView.heightAnchor.constraint(equalToConstant: 88),
            
            nameLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
            
            itemImageView.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -16),
            itemImageView.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: 70),
            itemImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Internal Methods
    
    func configure(with item: FruitsAndBerriesModels.Load.ViewModel.FruitsAndBerriesViewModelItem) {
        coloredView.backgroundColor = UIColor(hexString: item.color)
        nameLabel.text = item.name
        if let imageURL = item.imageURL {
            let url = Endpoint.image(imageUrl: imageURL).url
            self.itemImageView.sd_setImage(with: url)
        } else {
            self.itemImageView.image = UIImage(named: "placeholder")
        }
    }
}

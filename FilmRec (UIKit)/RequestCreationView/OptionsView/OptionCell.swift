//
//  OptionCell.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 04.08.2025.
//

import UIKit

final class OptionCell: UITableViewCell {
    lazy var optionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    static let reuseIdentifier = "optionCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(optionNameLabel)
        contentView.addSubview(checkmarkImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            optionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

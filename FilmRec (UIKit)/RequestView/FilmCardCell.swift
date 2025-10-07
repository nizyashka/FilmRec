//
//  FilmCardCell.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 08.09.2025.
//

import UIKit

final class FilmCardCell: UICollectionViewCell {
    static let reuseIdentifier = "FilmCardCell"
    
    lazy var filmPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(filmPosterImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmPosterImageView.heightAnchor.constraint(equalToConstant: 120),
            filmPosterImageView.widthAnchor.constraint(equalToConstant: 80),
            filmPosterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filmPosterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

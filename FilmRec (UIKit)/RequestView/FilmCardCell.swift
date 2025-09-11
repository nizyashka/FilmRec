//
//  FilmCardCell.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 08.09.2025.
//

import UIKit

final class FilmCardCell: UICollectionViewCell {
    static let reuseIdentifier = "FilmCardCell"
    
    private lazy var stabView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
//        contentView.backgroundColor = .backgroundWhite
        
//        contentView.addSubview(stabView)
        contentView.addSubview(filmPosterImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            stabView.heightAnchor.constraint(equalToConstant: 120),
//            stabView.widthAnchor.constraint(equalToConstant: 80),
//            stabView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            stabView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            filmPosterImageView.heightAnchor.constraint(equalToConstant: 120),
            filmPosterImageView.widthAnchor.constraint(equalToConstant: 80),
            filmPosterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filmPosterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

import UIKit

final class FilmCardCell: UICollectionViewCell {
    static let reuseIdentifier = "FilmCardCell"
    
    lazy var filmPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
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
            filmPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            filmPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmPosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filmPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

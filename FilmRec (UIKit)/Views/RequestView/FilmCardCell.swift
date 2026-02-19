import UIKit

final class FilmCardCell: UICollectionViewCell {
    static let reuseIdentifier = "FilmCardCell"
    
    lazy var filmTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .text
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var filmPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
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
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(filmTitleLabel)
        contentView.addSubview(filmPosterImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            filmTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            filmTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filmTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            filmPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            filmPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmPosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filmPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

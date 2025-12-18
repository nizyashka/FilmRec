import UIKit
import Kingfisher

final class RecommendedFilmViewController: UIViewController {
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(title: "Close",
                                            style: .plain,
                                            target: self,
                                            action: #selector(leftBarButtonTapped))
        
        leftBarButton.tintColor = .systemBlue
        
        return leftBarButton
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let systemName = viewModel.isInWatchlist() ? "clock.badge.xmark" : "clock.badge.checkmark"
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: systemName)!,
                                             style: .plain,
                                             target: self,
                                             action: #selector(rightBarButtonTapped))
        
        rightBarButton.tintColor = viewModel.isInWatchlist() ? .systemRed : .systemGreen
        
        return rightBarButton
    }()
    
    private lazy var filmPosterImageView: UIImageView = {
        guard let posterURL = viewModel.film.posterPath,
              let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + posterURL) else {
            assertionFailure("[RecommendedFilmView] - filmPosterImageView: Error getting a URL of poster.")
            return UIImageView()
        }
        
        let imageView = UIImageView()
        let processor = RoundCornerImageProcessor(cornerRadius: 30)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL,
                              options: [.processor(processor)])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var filmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.film.originalTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var filmRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        guard let filmRatingString = viewModel.film.voteAverage else {
            label.text = "???"
            return label
        }
        
        label.text = "\(filmRatingString)"
        
        return label
    }()
    
    private lazy var filmRatingImageView: UIImageView = {
        let imageView = UIImageView()
        let ratingImage = UIImage(systemName: "star.fill")
        imageView.image = ratingImage?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var filmOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        
        guard let overview = viewModel.film.overview else {
            label.text = "\tThis film has no overview."
            return label
        }
        
        label.text = "\t\(overview)"
        
        return label
    }()
    
    private let viewModel: RecommendedFilmViewModel
    
    init(viewModel: RecommendedFilmViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(filmPosterImageView)
        view.addSubview(filmTitleLabel)
        view.addSubview(filmRatingLabel)
        view.addSubview(filmRatingImageView)
        view.addSubview(filmOverviewLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmPosterImageView.heightAnchor.constraint(equalToConstant: 360),
            filmPosterImageView.widthAnchor.constraint(equalToConstant: 240),
            filmPosterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            filmPosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filmTitleLabel.topAnchor.constraint(equalTo: filmPosterImageView.bottomAnchor, constant: 16),
            filmTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filmTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filmTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filmRatingLabel.topAnchor.constraint(equalTo: filmTitleLabel.bottomAnchor, constant: 8),
            filmRatingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filmRatingImageView.leadingAnchor.constraint(equalTo: filmRatingLabel.trailingAnchor, constant: 8),
            filmRatingImageView.centerYAnchor.constraint(equalTo: filmRatingLabel.centerYAnchor),
            
            filmOverviewLabel.topAnchor.constraint(equalTo: filmRatingLabel.bottomAnchor, constant: 16),
            filmOverviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filmOverviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func leftBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func rightBarButtonTapped() {
        if viewModel.isInWatchlist() {
            viewModel.removeFromWatchlist()
        } else {
            viewModel.addToWatchlist()
        }
        
        UIView.animate(withDuration: 1) {
            let isInWatchlist = self.viewModel.isInWatchlist()
            
            self.rightBarButton.image = UIImage(systemName: isInWatchlist ? "clock.badge.xmark" : "clock.badge.checkmark")
            self.rightBarButton.tintColor = isInWatchlist ? .systemRed : .systemGreen
        }
    }
}

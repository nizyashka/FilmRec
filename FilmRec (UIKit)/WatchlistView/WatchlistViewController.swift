import UIKit
import Kingfisher

final class WatchlistViewController: UIViewController {
    private lazy var filmsInWatchlistCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilmCardCell.self, forCellWithReuseIdentifier: FilmCardCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    var viewModel: WatchlistViewModel
    
    init(viewModel: WatchlistViewModel) {
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
        setupBindings()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Watchlist"
        
        view.addSubview(filmsInWatchlistCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmsInWatchlistCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filmsInWatchlistCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            filmsInWatchlistCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filmsInWatchlistCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.filmsInWatchlistCollectionView.reloadData()
        }
    }
    
    private func setupBindings() {
        viewModel.controllerDidChangeContent = updateCollectionView
    }
}

extension WatchlistViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filmsInWatchlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCardCell.reuseIdentifier, for: indexPath) as? FilmCardCell else {
            assertionFailure("[WatchlistViewController] - collectionView: Was unable to dequeue a cell.")
            return UICollectionViewCell()
        }
        
        let film = viewModel.filmsInWatchlist[indexPath.row]
        
        guard let posterURL = film.posterPath,
              let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + posterURL) else {
            assertionFailure("[RecommendedFilmView] - filmPosterImageView: Error getting a URL of poster.")
            cell.filmPosterImageView.isHidden = true
            return cell
        }
        
        cell.filmPosterImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let film = viewModel.filmsInWatchlist[indexPath.row]
        
        let recommendedFilmViewModel = RecommendedFilmViewModel(film: film)
        let recommendedFilmViewController = RecommendedFilmViewController(viewModel: recommendedFilmViewModel)
        let navigationController = UINavigationController(rootViewController: recommendedFilmViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 120)
    }
}

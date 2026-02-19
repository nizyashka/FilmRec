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
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.largeTitleDisplayMode = .always
        title = "Watchlist"
        
        configureNavBarItem()
        
        view.addSubview(filmsInWatchlistCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmsInWatchlistCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            filmsInWatchlistCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filmsInWatchlistCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filmsInWatchlistCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.filmsInWatchlistCollectionView.reloadData()
        }
    }
    
    private func setupBindings() {
        viewModel.controllerDidChangeContent = updateCollectionView
    }
    
    private func configureNavBarItem() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: makeBarButtonMenu())
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func makeBarButtonMenu() -> UIMenu {
        let themeAction = UIAction(title: "Change Theme", image: UIImage(systemName: "paintbrush"), handler: { [weak self] _ in
            self?.changeTheme()
        })
        
        let submenuActions = WatchlistSortingOptions.allCases.map { sortingOption in
            UIAction(
                title: sortingOption.rawValue,
                state: sortingOption == viewModel.selectedSortingOption ? .on : .off
            ) { [weak self] _ in
                self?.viewModel.selectedSortingOption = sortingOption
                self?.configureNavBarItem()
                self?.updateCollectionView()
            }
        }
        
        let submenuOptions: [UIMenuElement] = submenuActions
        let submenu = UIMenu(title: "Sort By", subtitle: viewModel.selectedSortingOption.rawValue, image: UIImage(systemName: "arrow.up.arrow.down"), children: submenuOptions)
        
        let menuOptions: [UIMenuElement] = [themeAction, submenu]
        let menu = UIMenu(children: menuOptions)
        
        return menu
    }
    
    private func changeTheme() {
        let appTheme = UserDefaults.standard.bool(forKey: "appTheme")
        UserDefaults.standard.set(!appTheme, forKey: "appTheme")
        
        NotificationCenter.default.post(
            name: .themeDidChange,
            object: nil
        )
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
        
        cell.filmTitleLabel.text = film.originalTitle
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
        let width = (collectionView.bounds.width - 24) / 4
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

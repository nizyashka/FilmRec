import UIKit
import ProgressHUD

final class RequestViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var optionsTabsLabel: UILabel = {
        let label = UILabel()
        label.text = "REQUEST OPTIONS"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var optionsTabsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LockedOptionsTabCell.self, forCellReuseIdentifier: LockedOptionsTabCell.reuseIdentifier)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var previouslyRecommendedLabel: UILabel = {
        let label = UILabel()
        label.text = "Previously recommended"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .text
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var previouslyRecommendedFilmsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilmCardCell.self, forCellWithReuseIdentifier: FilmCardCell.reuseIdentifier)
        collectionView.backgroundColor = .secondaryBackground
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var executeRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Execute", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(executeRequestButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(deleteRequestButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel: RequestViewModel
    
    private var previouslyRecommendedFilmsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    init(viewModel: RequestViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadPreviouslyRecommendedFilms()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondaryBackground
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.largeTitleDisplayMode = .never
        title = viewModel.request.name
        
        view.addSubview(scrollView)
        scrollView.addSubview(optionsTabsLabel)
        scrollView.addSubview(optionsTabsTableView)
        scrollView.addSubview(previouslyRecommendedLabel)
        scrollView.addSubview(previouslyRecommendedFilmsCollectionView)
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(executeRequestButton)
        buttonsStack.addArrangedSubview(deleteRequestButton)
    }
    
    private func setupConstraints() {
        previouslyRecommendedFilmsCollectionViewHeightConstraint = previouslyRecommendedFilmsCollectionView.heightAnchor.constraint(equalToConstant: countHeightForCollectionView())
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            optionsTabsLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            optionsTabsLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            
            optionsTabsTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.optionsTabs.count * 45 - 1)),
            optionsTabsTableView.topAnchor.constraint(equalTo: optionsTabsLabel.bottomAnchor, constant: 6),
            optionsTabsTableView.bottomAnchor.constraint(equalTo: previouslyRecommendedLabel.topAnchor, constant: -32),
            optionsTabsTableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            optionsTabsTableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            previouslyRecommendedLabel.topAnchor.constraint(equalTo: optionsTabsTableView.bottomAnchor, constant: 32),
            previouslyRecommendedLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            
            previouslyRecommendedFilmsCollectionViewHeightConstraint,
            previouslyRecommendedFilmsCollectionView.topAnchor.constraint(equalTo: previouslyRecommendedLabel.bottomAnchor, constant: 16),
            previouslyRecommendedFilmsCollectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            previouslyRecommendedFilmsCollectionView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            previouslyRecommendedFilmsCollectionView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            buttonsStack.heightAnchor.constraint(equalToConstant: 45),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func executeRequestButtonTapped() {
        ProgressHUD.animate()
        
        viewModel.executeRequest { [weak self] result in
            switch result {
            case .success(let film):
                self?.viewModel.loadPreviouslyRecommendedFilms()
                DispatchQueue.main.async {
                    ProgressHUD.succeed()
                    
                    self?.previouslyRecommendedFilmsCollectionView.reloadData()
                    self?.previouslyRecommendedFilmsCollectionView.layoutIfNeeded()
                    self?.previouslyRecommendedFilmsCollectionViewHeightConstraint.constant = self?.previouslyRecommendedFilmsCollectionView.collectionViewLayout.collectionViewContentSize.height ?? 0
                    
                    let recommendedFilmViewModel = RecommendedFilmViewModel(film: film)
                    let recommendedFilmViewController = RecommendedFilmViewController(viewModel: recommendedFilmViewModel)
                    let navigationController = UINavigationController(rootViewController: recommendedFilmViewController)
                    navigationController.modalPresentationStyle = .pageSheet
                    self?.present(navigationController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    ProgressHUD.failed()
                    
                    let alert = UIAlertController(title: "Error", message: "An error occurred while recommending the film. Please try enabling a VPN.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
                        self?.executeRequestButtonTapped()
                    }))
                    self?.present(alert, animated: true)
                }
                
//                assertionFailure("[RequestViewController] - executeRequestButtonTapped: Error getting a film while executing request (\(error))")
            }
        }
    }
    
    @objc private func deleteRequestButtonTapped() {
        let alert = UIAlertController(title: "Delete this request?", message: "Once this request is deleted, it cannot be restored. Any recommended films that are not in the watchlist and are not associated with other requests will also be deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.viewModel.deleteRequest()
        }))
        self.present(alert, animated: true)
    }
    
    private func countHeightForCollectionView() -> CGFloat {
        var numberOfRows = 0
        
        if viewModel.previouslyRecommendedFilms.count % 4 > 0 {
            numberOfRows = (viewModel.previouslyRecommendedFilms.count / 4) + 1
        } else {
            numberOfRows = viewModel.previouslyRecommendedFilms.count / 4
        }
        
        return CGFloat(numberOfRows * 128)
    }
}

extension RequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.optionsTabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LockedOptionsTabCell.reuseIdentifier, for: indexPath) as? LockedOptionsTabCell else {
            assertionFailure("[RequestCreationViewController] - tableView: Error dequeueing a cell.")
            return UITableViewCell()
        }
        
        (cell.optionsTabNameLabel.text, cell.pickedOptionLabel.text) = viewModel.getTabNameAndPickedOption(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension RequestViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.previouslyRecommendedFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCardCell.reuseIdentifier, for: indexPath) as? FilmCardCell else {
            assertionFailure("[RequestViewController] - collectionView: unable to dequeue a cell.")
            return UICollectionViewCell()
        }
        
        let film = viewModel.previouslyRecommendedFilms[indexPath.row]
        
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
        
        let film = viewModel.previouslyRecommendedFilms[indexPath.row]
        
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

//
//  RequestViewController.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 19.05.2025.
//

import UIKit

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
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var previouslyRecommendedFilmsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilmCardCell.self, forCellWithReuseIdentifier: FilmCardCell.reuseIdentifier)
        collectionView.backgroundColor = .backgroundWhite
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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
    
    private let viewModel: RequestViewModel
    
    init(viewModel: RequestViewModel) {
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
        view.backgroundColor = .backgroundWhite
        navigationItem.largeTitleDisplayMode = .never
        title = viewModel.request.name
        
        view.addSubview(scrollView)
        scrollView.addSubview(optionsTabsLabel)
        scrollView.addSubview(optionsTabsTableView)
        scrollView.addSubview(previouslyRecommendedLabel)
        scrollView.addSubview(previouslyRecommendedFilmsCollectionView)
        view.addSubview(executeRequestButton)
    }
    
    private func setupConstraints() {
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
            
            //Добавить высоту
            previouslyRecommendedFilmsCollectionView.heightAnchor.constraint(equalToConstant: 4.25*120),
            previouslyRecommendedFilmsCollectionView.topAnchor.constraint(equalTo: previouslyRecommendedLabel.bottomAnchor, constant: 16),
            previouslyRecommendedFilmsCollectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            previouslyRecommendedFilmsCollectionView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            previouslyRecommendedFilmsCollectionView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            executeRequestButton.heightAnchor.constraint(equalToConstant: 60),
            executeRequestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            executeRequestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            executeRequestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func executeRequestButtonTapped() {
        viewModel.executeRequest { result in
            switch result {
            case .success(let film):
                DispatchQueue.main.async {
                    let recommendedFilmViewModel = RecommendedFilmViewModel(requestCoreData: self.viewModel.requestCoreData, film: film)
                    let recommendedFilmViewController = RecommendedFilmViewController(viewModel: recommendedFilmViewModel)
                    let navigationController = UINavigationController(rootViewController: recommendedFilmViewController)
                    navigationController.modalPresentationStyle = .pageSheet
                    self.present(navigationController, animated: true)
                }
            case .failure(let error):
                assertionFailure("[RequestViewController] - executeRequestButtonTapped: Error getting a film while executing request (\(error))")
            }
        }
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
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCardCell.reuseIdentifier, for: indexPath) as? FilmCardCell else {
            assertionFailure("")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 120)
    }
}

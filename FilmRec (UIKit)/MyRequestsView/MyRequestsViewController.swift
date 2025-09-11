//
//  ViewController.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 18.04.2025.
//

import UIKit

class MyRequestsViewController: UIViewController {
    private lazy var requestsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.reuseIdentifier)
        
        tableView.backgroundColor = .backgroundWhite
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let requestsStore = RequestsStore.shared
    
    private let viewModel: MyRequestsViewModel?
    
    init(viewModel: MyRequestsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestsStore.requestsStoreDelegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        configureNavigationTitle()
        configureNavBarItem()
        
        view.addSubview(requestsTableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            requestsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            requestsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            requestsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            requestsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "My requests"
    }
    
    private func configureNavBarItem() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: nil)
        
        navigationItem.rightBarButtonItem = barButton
    }
}

extension MyRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.requests.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let requestCell = tableView.dequeueReusableCell(withIdentifier: RequestCell.reuseIdentifier, for: indexPath) as? RequestCell else {
            assertionFailure("[MyRequestsViewController] - tableView: Failed to dequeue a cell.")
            return UITableViewCell()
        }
        
        requestCell.nameLabel.text = viewModel?.requests[indexPath.row].name
        requestCell.backgroundColor = .backgroundWhite
        
        return requestCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let request = viewModel?.requests[indexPath.row],
              let requestCoreData = viewModel?.requestsCoreData[indexPath.row] else {
            assertionFailure("[MyRequestsViewController] - tableView: No request with such indexPath found or no viewModel.")
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let requestObject = Request(name: request.name,
//                              genre: request.genre,
//                              country: request.country,
//                              director: request.director,
//                              decade: request.decade)
        
        let requestViewModel = RequestViewModel(request: request, requestCoreData: requestCoreData)
        
        let requestViewController = RequestViewController(viewModel: requestViewModel)
        
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(requestViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension MyRequestsViewController: RequestsStoreDelegate {
    func updateTableOrCollectionView() {
        requestsTableView.reloadData()
    }
}

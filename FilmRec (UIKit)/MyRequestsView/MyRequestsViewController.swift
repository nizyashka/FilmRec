import UIKit

class MyRequestsViewController: UIViewController {
    private lazy var requestsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.reuseIdentifier)
        
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let requestsStore = RequestsStore.shared
    
    private let viewModel: MyRequestsViewModel
    
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
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.largeTitleDisplayMode = .always
        title = "My requests"
    }
    
    private func configureNavBarItem() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: makeBarButtonMenu())
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func makeBarButtonMenu() -> UIMenu {
        let themeAction = UIAction(title: "Change Theme", image: UIImage(systemName: "paintbrush"), handler: { [weak self] _ in
            self?.changeTheme()
        })
        
        let submenuActions = RequestFilters.allCases.map { filter in
            UIAction(
                title: filter.rawValue,
                state: filter == viewModel.selectedFilter ? .on : .off
            ) { [weak self] _ in
                self?.viewModel.selectedFilter = filter
                self?.configureNavBarItem()
            }
        }
        
        let submenuOptions: [UIMenuElement] = submenuActions
        let submenu = UIMenu(title: "Sort By", subtitle: viewModel.selectedFilter.rawValue, image: UIImage(systemName: "arrow.up.arrow.down"), children: submenuOptions)
        
        let menuOptions: [UIMenuElement] = [themeAction, submenu]
        let menu = UIMenu(children: menuOptions)
        
        return menu
    }
    
    private func changeTheme() {
        //TODO: Добавить смену темы
        print("Change theme")
    }
}

extension MyRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let requestCell = tableView.dequeueReusableCell(withIdentifier: RequestCell.reuseIdentifier, for: indexPath) as? RequestCell else {
            assertionFailure("[MyRequestsViewController] - tableView: Failed to dequeue a cell.")
            return UITableViewCell()
        }
        
        requestCell.nameLabel.text = viewModel.requests[indexPath.row].name
        requestCell.color = viewModel.requests[indexPath.row].color
        requestCell.backgroundColor = .background
        
        return requestCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = viewModel.requests[indexPath.row]
        let requestCoreData = viewModel.requestsCoreData[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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

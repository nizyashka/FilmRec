import UIKit

final class RequestCreationViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var requestNameLabel: UILabel = {
        let label = UILabel()
        label.text = "REQUEST NAME"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
    private lazy var requestNameTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.delegate = self
        textField.placeholder = "New request"
        textField.backgroundColor = .uiElementsAccent
        textField.tintColor = .systemBlue
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var optionsTabsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OptionsTabCell.self, forCellReuseIdentifier: OptionsTabCell.reuseIdentifier)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var saveRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(saveRequestButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel: RequestCreationViewModel
    
    init(viewModel: RequestCreationViewModel) {
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
        setBinding()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondaryBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.largeTitleDisplayMode = .never
        title = "New request"
        
        let leftBarButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelBarButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = leftBarButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(requestNameLabel)
        scrollView.addSubview(requestNameTextField)
        scrollView.addSubview(optionsTabsLabel)
        scrollView.addSubview(optionsTabsTableView)
        view.addSubview(saveRequestButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            requestNameLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            requestNameLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            
            requestNameTextField.heightAnchor.constraint(equalToConstant: 45),
            requestNameTextField.topAnchor.constraint(equalTo: requestNameLabel.bottomAnchor, constant: 6),
            requestNameTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            requestNameTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            optionsTabsLabel.topAnchor.constraint(equalTo: requestNameTextField.bottomAnchor, constant: 32),
            optionsTabsLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            
            optionsTabsTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.optionsTabs.count * 45 - 1)),
            optionsTabsTableView.topAnchor.constraint(equalTo: optionsTabsLabel.bottomAnchor, constant: 6),
            optionsTabsTableView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            optionsTabsTableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            optionsTabsTableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            saveRequestButton.heightAnchor.constraint(equalToConstant: 45),
            saveRequestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveRequestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveRequestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func cancelBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveRequestButtonTapped() {
        if let requestName = requestNameTextField.text, !requestName.isEmpty {
            viewModel.saveWithoutExecution(requestName: requestName)
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Request name is missing", message: "You have to give request a name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func setBinding() {
        viewModel.updatePickedOptionLabel = updatePickedOptionLabel
    }
    
    private func updatePickedOptionLabel(at indexPath: IndexPath, to pickedOption: String) {
        guard let optionsTabCell = optionsTabsTableView.cellForRow(at: indexPath) as? OptionsTabCell else {
            assertionFailure("[RequestCreationViewController] - updatePickedOptionLabel: Error getting a cell by IndexPath.")
            return
        }
        
        optionsTabCell.pickedOptionLabel.text = pickedOption
    }
}

extension RequestCreationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsTabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTabCell.reuseIdentifier, for: indexPath) as? OptionsTabCell else {
            assertionFailure("[RequestCreationViewController] - tableView: Error dequeueing a cell.")
            return UITableViewCell()
        }
        
        (cell.optionsTabNameLabel.text, cell.pickedOptionLabel.text) = viewModel.getTabNameAndPickedOption(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (optionsTabName, selectedOption) = viewModel.getTabNameAndPickedOption(at: indexPath.row)
        
        let optionsViewModel = OptionsViewModel(delegate: viewModel, optionsTabName: optionsTabName, selectedOption: selectedOption)
        let optionsTabViewController = OptionsViewController(viewModel: optionsViewModel)
        navigationController?.pushViewController(optionsTabViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RequestCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  TrackerCreationViewController.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 01.07.2025.
//

import UIKit

final class RequestCreationViewController: UIViewController {
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
        textField.placeholder = "New request"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
//        textField.borderStyle = .roundedRect
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
    
    private lazy var saveWithoutExecutionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Without Execution", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(saveWithoutExecutionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
//    private let requestsStore = RequestsStore.shared
    
//    private let optionsTabs = ["Genre", "Country", "Director", "Decade"]
    
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
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundWhite
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        title = "New request"
        
        let leftBarButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelBarButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = leftBarButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray
        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
        
        view.addSubview(requestNameLabel)
        view.addSubview(requestNameTextField)
        view.addSubview(optionsTabsLabel)
        view.addSubview(optionsTabsTableView)
        view.addSubview(saveWithoutExecutionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            requestNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            requestNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            requestNameTextField.heightAnchor.constraint(equalToConstant: 45),
            requestNameTextField.topAnchor.constraint(equalTo: requestNameLabel.bottomAnchor, constant: 6),
            requestNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            requestNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            optionsTabsLabel.topAnchor.constraint(equalTo: requestNameTextField.bottomAnchor, constant: 32),
            optionsTabsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            optionsTabsTableView.topAnchor.constraint(equalTo: optionsTabsLabel.bottomAnchor, constant: 6),
            optionsTabsTableView.bottomAnchor.constraint(equalTo: optionsTabsTableView.topAnchor, constant: CGFloat(viewModel.optionsTabs.count * 45 - 1)),
            optionsTabsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTabsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveWithoutExecutionButton.heightAnchor.constraint(equalToConstant: 95),
            saveWithoutExecutionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveWithoutExecutionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveWithoutExecutionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func cancelBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveWithoutExecutionButtonTapped() { //Вынести во ViewModel и Model
        if let requestName = requestNameTextField.text, !requestName.isEmpty {
            viewModel.saveWithoutExecution(requestName: requestName)
            dismiss(animated: true)
        } else {
            // Показать алерт
        }
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
        
//        cell.optionsTabNameLabel.text = viewModel.optionsTabs[indexPath.row]
//        cell.pickedOptionLabel.text = "Any"
        
        (cell.optionsTabNameLabel.text, cell.pickedOptionLabel.text) = viewModel.getTabNameAndPickedOption(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionsViewModel = OptionsViewModel(delegate: viewModel, optionsTabName: viewModel.optionsTabs[indexPath.row])
        let optionsTabViewController = OptionsViewController(viewModel: optionsViewModel)
        navigationController?.pushViewController(optionsTabViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

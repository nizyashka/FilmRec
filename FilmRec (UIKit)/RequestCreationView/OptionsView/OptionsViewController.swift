//
//  OptionsTabViewController.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 04.08.2025.
//

import UIKit

final class OptionsViewController: UIViewController {
    private lazy var optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.reuseIdentifier)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let viewModel: OptionsViewModel
    
    init(viewModel: OptionsViewModel) {
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
        title = viewModel.optionsTabName
        
        view.addSubview(optionsTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            optionsTableView.bottomAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: CGFloat(viewModel.options.count * 45 - 1)),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.reuseIdentifier, for: indexPath) as? OptionCell else {
            assertionFailure("[OptionsViewController] - tableView: Error dequeueing a cell.")
            return UITableViewCell()
        }
        
        cell.optionNameLabel.text = viewModel.options[indexPath.row]
        
        cell.checkmarkImageView.isHidden = (viewModel.selectedOption == "Any" && indexPath.row == 0) ? false : true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: visibleIndexPath) as? OptionCell {
                cell.checkmarkImageView.isHidden = true
            } else {
                assertionFailure("[OptionsViewController] - tableView: Error getting a cell from indexPath.")
                return
            }
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? OptionCell {
            guard let optionNameLabelText = selectedCell.optionNameLabel.text else {
                assertionFailure("[OptionsViewController] - tableView: Error getting a text from label.")
                return
            }
            
            viewModel.selectedOption = optionNameLabelText
            selectedCell.checkmarkImageView.isHidden = false
            
            print(viewModel.selectedOption)
        } else {
            assertionFailure("[OptionsViewController] - tableView: Error getting a cell from indexPath.")
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

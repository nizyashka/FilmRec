//
//  RequestViewController.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 19.05.2025.
//

import UIKit

final class RequestViewController: UIViewController {
    private lazy var requestNameLabel: UILabel = {
        let requestNameLabel = UILabel()
        requestNameLabel.text = self.name
        
        return requestNameLabel
    }()
    
    private let name: String
    private let genre: String
    private let country: String
    private let director: String
    private let decade: String
    
    init(name: String,
         genre: String,
         country: String,
         director: String,
         decade: String) {
        
        self.name = name
        self.genre = genre
        self.country = country
        self.director = director
        self.decade = decade
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPink
        
        configureNavigationTitle()
    }
    
    private func configureNavigationTitle() {
        navigationItem.largeTitleDisplayMode = .never
        title = name
    }
}

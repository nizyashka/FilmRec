//
//  WatchlistViewController.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 20.05.2025.
//

import Foundation
import UIKit

final class WatchlistViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Watchlist"
    }
}

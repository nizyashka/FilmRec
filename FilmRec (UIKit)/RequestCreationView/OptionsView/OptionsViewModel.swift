//
//  OptionsViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 19.08.2025.
//

import Foundation

protocol OptionsViewModelDelegate: AnyObject {
    func setPickedOption(optionsTabName: String, selectedOption: String)
}

final class OptionsViewModel {
    lazy var options: [String] = {
        return model.getSuitableOptions(optionsTabName: optionsTabName)
    }()
    
    let optionsTabName: String
    var selectedOption: String {
        didSet {
            optionsViewModelDelegate?.setPickedOption(optionsTabName: optionsTabName, selectedOption: selectedOption)
        }
    }
    
    private let model = OptionsModel()
    
    private weak var optionsViewModelDelegate: OptionsViewModelDelegate?
    
    init(delegate: OptionsViewModelDelegate, optionsTabName: String, selectedOption: String = "Any") {
        self.optionsViewModelDelegate = delegate
        self.optionsTabName = optionsTabName
        self.selectedOption = selectedOption
    }
}

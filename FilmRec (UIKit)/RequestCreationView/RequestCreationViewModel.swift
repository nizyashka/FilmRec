//
//  RequestCreationViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 04.08.2025.
//

import Foundation

final class RequestCreationViewModel {
    var updatePickedOptionLabel: (IndexPath, String) -> Void = { _, _ in }
    
    let optionsTabs = ["Genre", "Country", "Director", "Decade"]
    
    var pickedGenre = "Any"
    var pickedCountry = "Any"
    var pickedDirector = "Any"
    var pickedDecade = "Any"
    
    private let requestsStore = RequestsStore.shared
    
    func saveWithoutExecution(requestName: String) {
//        requestsStore.addRequestToCoreData(
//            name: requestName,
//            genre: pickedGenre,
//            country: pickedCountry,
//            director: pickedDirector,
//            decade: pickedDecade)
        
        print(requestName, pickedGenre, pickedCountry, pickedDirector, pickedDecade) // Создать объект Request
    }
    
    func getTabNameAndPickedOption(at index: Int) -> (String, String) {
        let optionsTabName = optionsTabs[index]
        var pickedOption = "Any"
        
        switch optionsTabName {
        case "Genre":
            pickedOption = pickedGenre
        case "Country":
            pickedOption = pickedCountry
        case "Director":
            pickedOption = pickedDirector
        case "Decade":
            pickedOption = pickedDecade
        default:
            assertionFailure("[RequestCreationViewModel] - setPickedOption: No such optionsTabName exists.")
        }
        
        return (optionsTabName, pickedOption)
    }
}

extension RequestCreationViewModel: OptionsViewModelDelegate {
    func setPickedOption(optionsTabName: String, selectedOption: String) {
        switch optionsTabName {
        case "Genre":
            pickedGenre = selectedOption
            updatePickedOptionLabel(IndexPath(row: 0, section: 0), selectedOption)
        case "Country":
            pickedCountry = selectedOption
            updatePickedOptionLabel(IndexPath(row: 1, section: 0), selectedOption)
        case "Director":
            pickedDirector = selectedOption
            updatePickedOptionLabel(IndexPath(row: 2, section: 0), selectedOption)
        case "Decade":
            pickedDecade = selectedOption
            updatePickedOptionLabel(IndexPath(row: 3, section: 0), selectedOption)
        default:
            assertionFailure("[RequestCreationViewModel] - setPickedOption: No such optionsTabName exists.")
        }
    }
}

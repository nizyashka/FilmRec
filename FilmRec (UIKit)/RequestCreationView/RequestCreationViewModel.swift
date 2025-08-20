//
//  RequestCreationViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 04.08.2025.
//

import Foundation

final class RequestCreationViewModel {
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
    
    func getTabNameAndPickedOption(index: Int) -> (String, String) {
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
        case "Country":
            pickedCountry = selectedOption
        case "Director":
            pickedDirector = selectedOption
        case "Decade":
            pickedDecade = selectedOption
        default:
            assertionFailure("[RequestCreationViewModel] - setPickedOption: No such optionsTabName exists.")
        }
    }
}

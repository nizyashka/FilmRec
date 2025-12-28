import Foundation

protocol OptionsViewModelDelegate: AnyObject {
    func setPickedOption(optionsTabName: String, selectedOption: String)
}

final class OptionsViewModel {
    lazy var options: [String] = {
        return getSuitableOptions(optionsTabName: optionsTabName)
    }()
    
    let optionsTabName: String
    var selectedOption: String {
        didSet {
            optionsViewModelDelegate?.setPickedOption(optionsTabName: optionsTabName, selectedOption: selectedOption)
        }
    }
    
    private weak var optionsViewModelDelegate: OptionsViewModelDelegate?
    
    init(delegate: OptionsViewModelDelegate, optionsTabName: String, selectedOption: String = "Any") {
        self.optionsViewModelDelegate = delegate
        self.optionsTabName = optionsTabName
        self.selectedOption = selectedOption
    }
    
    func getSuitableOptions(optionsTabName: String) -> [String] {
        switch optionsTabName {
        case "Genre":
            return ["Any", "Comedy", "Horror", "Fantasy", "Thriller", "Action", "Drama"]
        case "Country":
            return ["Any", "USA", "Great Britain", "France", "Russia", "Italy", "Japan"]
        case "Director":
            return ["Any", "Martin Scorsese", "Quentin Tarantino", "Stanley Kubrick"]
        case "Decade":
            return ["Any", "2020s", "2010s", "2000s", "1990s", "1980s", "1970s", "1960s", "1950s", "1940s", "1930s"]
        default:
            return []
        }
    }
}

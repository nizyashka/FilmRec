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
            return [
                "Any", "Action", "Adventure",
                "Animation", "Comedy", "Crime",
                "Documentary", "Drama", "Family",
                "Fantasy", "History", "Horror",
                "Music", "Mystery", "Romance",
                "Science Fiction", "Thriller", "War", "Western"
            ]
        case "Country":
            return [
                "Any", "Denmark", "France",
                "Germany", "Great Britain", "Hong Kong",
                "Italy", "Japan", "Norway",
                "Russia", "South Korea", "Spain",
                "Sweden", "Turkey", "USA"
            ]
            
        case "Director":
            return [
                "Any", "Akira Kurosawa", "Alfred Hitchcock",
                "Andrei Tarkovsky", "Billy Wilder", "Brian De Palma",
                "Buster Keaton", "Christopher Nolan", "Coen brothers",
                "Danny Boyle", "David Fincher", "David Lynch",
                "Denis Villeneuve", "Edgar Wright", "Francis Ford Coppola",
                "François Truffaut", "Hayao Miyazaki", "Ingmar Bergman",
                "James Cameron", "John Carpenter", "Lars von Trier",
                "Martin Scorsese", "Michael Mann", "Orson Welles",
                "Paul Thomas Anderson", "Peter Jackson", "Quentin Tarantino",
                "Ridley Scott", "Robert Rodriguez", "Robert Zemeckis",
                "Roman Polanski", "Sergio Leone", "Sidney Lumet",
                "Stanley Kubrick", "Steven Spielberg", "Wes Anderson",
                "Woody Allen"
            ]
        case "Decade":
            return [
                "Any", "2020s", "2010s",
                "2000s", "1990s", "1980s",
                "1970s", "1960s", "1950s",
                "1940s", "1930s"
            ]
        default:
            return []
        }
    }
}

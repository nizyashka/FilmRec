import Foundation

final class RequestViewModel {
    let optionsTabs = ["Genre", "Country", "Director", "Decade"]
    
    var request: Request
    var requestCoreData: RequestCoreData
    private(set) var previouslyRecommendedFilms: [Film] = []
    
    let openAIService = OpenAIService.shared
    let tmdbService = TMDBService.shared
    let openAIResponseObjectDecoder = OpenAIResponseObjectDecoder.shared
    let tmdbResponseObjectDecoder = TMDBResponseObjectDecoder.shared
    let filmsStore = FilmsStore.shared
    let requestsStore = RequestsStore.shared
    
    init(request: Request, requestCoreData: RequestCoreData) {
        self.request = request
        self.requestCoreData = requestCoreData
    }
    
    func getTabNameAndPickedOption(at index: Int) -> (String, String) {
        let optionsTabName = optionsTabs[index]
        var pickedOption = "Any"
        
        switch optionsTabName {
        case "Genre":
            pickedOption = request.genre
        case "Country":
            pickedOption = request.country
        case "Director":
            pickedOption = request.director
        case "Decade":
            pickedOption = request.decade
        default:
            assertionFailure("[RequestCreationViewModel] - setPickedOption: No such optionsTabName exists.")
        }
        
        return (optionsTabName, pickedOption)
    }
    
    func executeRequest(completion: @escaping (Result<Film, Error>) -> Void) {
        var films: [String] = []
        
        for film in previouslyRecommendedFilms {
            films.append(film.originalTitle)
        }
        
        let prompt = PromptCreation.shared.createPrompt(for: request, exclude: films)
        
        getFilmDetails(for: prompt) { result in
            switch result {
            case .success(let filmTMDB):
                guard let filmCoreData = self.filmsStore.addFilmToCoreData(filmTMDB: filmTMDB, requestCoreData: self.requestCoreData),
                      let film = self.filmsStore.toFilm(from: filmCoreData) else {
                    assertionFailure("[RequestViewModel] - executeRequest: Error saving a film to Core Data or converting it.")
                    completion(.failure(CoreDataErrors.errorSaving))
                    return
                }
                
                completion(.success(film))
            case .failure(let error):
                completion(.failure(error))
                assertionFailure("[RequestViewModel] - executeRequest: Error getting a film while executing request (\(error))")
            }
        }
    }
    
    func deleteRequest() {
        requestsStore.removeRequestFromCoreData(requestCoreData)
    }
    
    private func getResponseFromOpenAI(with prompt: String, completion: @escaping (Result<Array<String>, Error>) -> Void) {
        openAIService.fetchOpenAIResponse(with: prompt) { result in
            switch result {
            case .success(let data):
                guard let decodedResponseText = self.openAIResponseObjectDecoder.decodeOpenAIResponse(from: data) else {
                    return
                }
                
                let array = decodedResponseText.components(separatedBy: "/")
                completion(.success(array))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getFilmFromTMDB(titled film: String, shotIn year: String, completion: @escaping (Result<TMDBResponseObject, Error>) -> Void) {
        tmdbService.fetchTMDBResponse(for: film, shotIn: year) { result in
            switch result {
            case .success(let data):
                guard let decodedResponse = self.tmdbResponseObjectDecoder.decodeTMDBResponse(from: data) else {
                    return
                }
                
                completion(.success(decodedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getFilmDetails(for prompt: String, completion: @escaping (Result<FilmTMDB, Error>) -> Void) {
        getResponseFromOpenAI(with: prompt) { result in
            switch result {
            case .success(let array):
                let title = array[0]
                let year = array[1]
                self.getFilmFromTMDB(titled: title, shotIn: year) { result in
                    switch result {
                    case .success(let decodedResponse):
                        guard let films = decodedResponse.results else {
                            completion(.failure(NetworkingErrors.noData))
                            return
                        }
                        
                        //TODO: Добавить если не пустой
                        completion(.success(films[0]))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadPreviouslyRecommendedFilms() {
        guard let previouslyRecommendedFilmsCoreData = requestCoreData.films as? Set<FilmCoreData> else {
            assertionFailure("[RequestViewModel] - loadPreviouslyRecommendedFilms: Error getting previously recommended films for a request.")
            return
        }
        
        var previouslyRecommendedFilms: [Film] = []
        
        for filmCoreData in previouslyRecommendedFilmsCoreData {
            guard let film = filmsStore.toFilm(from: filmCoreData) else {
                assertionFailure("[RequestViewModel] - loadPreviouslyRecommendedFilms: Error getting or converting a film.")
                return
            }
            
            previouslyRecommendedFilms.append(film)
        }
        
        self.previouslyRecommendedFilms = previouslyRecommendedFilms
    }
}

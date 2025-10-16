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
        let prompt = PromptCreation.shared.createPrompt(for: request)
        
        getFilmDetails(for: prompt) { result in
            switch result {
            case .success(let film):
                self.filmsStore.addFilmToCoreData(id: film.id, request: self.requestCoreData)
                completion(.success(film))
            case .failure(let error):
                completion(.failure(error))
                assertionFailure("[RequestViewModel] - executeRequest: Error getting a film while executing request (\(error))")
            }
        }
    }
    
    func getResponseFromOpenAI(with prompt: String, completion: @escaping (Result<Array<String>, Error>) -> Void) {
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
    
    func getFilmFromTMDB(titled film: String, shotIn year: String, completion: @escaping (Result<TMDBResponseObject, Error>) -> Void) {
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
    
    func getFilmDetails(for prompt: String, completion: @escaping (Result<Film, Error>) -> Void) {
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
    
    func loadPreviouslyRecommendedFilms(completion: @escaping (() -> Void)) {
        guard let previouslyRecommendedFilmsCoreData = requestCoreData.films as? Set<FilmCoreData> else {
            assertionFailure("[RequestViewModel] - loadPreviouslyRecommendedFilms: Error getting previously recommended films for a request.")
            completion()
            return
        }
        
        var previouslyRecommendedFilms: [Film] = []
        let group = DispatchGroup()
        
        for filmCoreData in previouslyRecommendedFilmsCoreData {
            group.enter()
            self.tmdbService.fetchFilmByID(filmCoreData.id) { result in
                switch result {
                case .success(let data):
                    guard let responseObject = self.tmdbResponseObjectDecoder.decodeTMDBResponseForFilmByID(from: data) else {
                        assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error decoding data.")
                        completion()
                        return
                    }
                    
                    previouslyRecommendedFilms.append(responseObject)
                case .failure(let error):
                    assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from TMDB. Error - \(error.localizedDescription)")
                    completion()
                    return
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.previouslyRecommendedFilms = previouslyRecommendedFilms
            completion()
        }
    }
}

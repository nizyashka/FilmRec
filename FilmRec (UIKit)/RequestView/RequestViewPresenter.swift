////
////  RequestViewPresenter.swift
////  FilmRec (Storyboard)
////
////  Created by Алексей Непряхин on 19.05.2025.
////
//
//import Foundation
//
//protocol RequestViewPresenterProtocol: AnyObject {
//    var view:RequestViewControllerProtocol? { get set }
//    func getResponseFromOpenAI(with prompt: String, completion: @escaping (Result<Array<String>, Error>) -> Void)
//    func getFilmFromTMDB(titled film: String, shotIn year: String, completion: @escaping (Result<TMDBResponseObject, Error>) -> Void)
//    func getFilmDetails(completion: @escaping (Result<Film, Error>) -> Void)
//    func createPrompt() -> String
//}
//
//final class RequestViewPresenter: RequestViewPresenterProtocol {
//    weak var view: RequestViewControllerProtocol?
//    
//    let promptCreation = PromptCreation.shared
//    let openAIService = OpenAIService.shared
//    let tmdbService = TMDBService.shared
//    let openAIResponseObjectDecoder = OpenAIResponseObjectDecoder.shared
//    let tmdbResponseObjectDecoder = TMDBResponseObjectDecoder.shared
//    
//    func getResponseFromOpenAI(with prompt: String, completion: @escaping (Result<Array<String>, Error>) -> Void) {
//        openAIService.fetchOpenAIResponse(with: prompt) { result in
//            switch result {
//            case .success(let data):
//                guard let decodedResponseText = self.openAIResponseObjectDecoder.decodeOpenAIResponse(from: data) else {
//                    return
//                }
//                
//                let array = decodedResponseText.components(separatedBy: "/")
//                completion(.success(array))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getFilmFromTMDB(titled film: String, shotIn year: String, completion: @escaping (Result<TMDBResponseObject, Error>) -> Void) {
//        tmdbService.fetchTMDBResponse(for: film, shotIn: year) { result in
//            switch result {
//            case .success(let data):
//                guard let decodedResponse = self.tmdbResponseObjectDecoder.decodeTMDBResponse(from: data) else {
//                    return
//                }
//                
//                completion(.success(decodedResponse))
//            case .failure(let error):
//                print(error)
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getFilmDetails(completion: @escaping (Result<Film, Error>) -> Void) {
//       let prompt = createPrompt()
//        
//        getResponseFromOpenAI(with: prompt) { result in
//            switch result {
//            case .success(let array):
//                let title = array[0]
//                let year = array[1]
//                self.getFilmFromTMDB(titled: title, shotIn: year) { result in
//                    switch result {
//                    case .success(let decodedResponse):
//                        guard let films = decodedResponse.results else {
//                            completion(.failure(NetworkingErrors.noData))
//                            return
//                        }
//                        
//                        completion(.success(films[0]))
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func createPrompt() -> String {
//        let requestModel = Request(requestName: "First", genreName: "Any", countryName: "Any", directorName: "Any", decadeYears: "Any")
//        let prompt = promptCreation.createPrompt(for: requestModel)
//        
//        return prompt
//    }
//}

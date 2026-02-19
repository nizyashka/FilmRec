import Foundation

final class PromptCreation {
    static let shared = PromptCreation()
    
    private init() { }
    
    func createPrompt(for requestModel: Request, exclude films: [String]) -> String {
        var prompt: String = "Please, recommend me "
        
        switch requestModel.genre {
        case "Any":
            prompt += "a film of any genre, "
        default:
            prompt += "a \(requestModel.genre) film, "
        }
        
        switch requestModel.country {
        case "Any":
            prompt += "produced in any country "
        default:
            prompt += "produced in \(requestModel.country) "
        }
        
        switch requestModel.director {
        case "Any":
            prompt += "and directed by any director "
        default:
            prompt += "and directed by \(requestModel.director) "
        }
        
        switch requestModel.decade {
        case "Any":
            prompt += "in any decade."
        default:
            prompt += "in \(requestModel.decade)."
        }
        
        if !films.isEmpty {
            prompt += " Do not recommend me "
            
            for (index, film) in films.enumerated() {
                prompt += index == films.count - 1 ? "\(film)." : "\(film), "
            }
        }
        
        prompt += " In your response write only the title of the film without brackets or other symbols and a release year of that film. The title and the year have to be divided by / without spaces."
        
        return(prompt)
    }
}

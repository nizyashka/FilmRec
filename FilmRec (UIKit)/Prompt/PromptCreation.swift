import Foundation

final class PromptCreation {
    static let shared = PromptCreation()
    
    private init() { }
    
    func createPrompt(for requestModel: Request, exclude films: [String]) -> String {
        var prompt: String = "Please, recommend me "
        
        switch requestModel.genre {
        case "Comedy":
            prompt += "a comedy film, "
        case "Horror":
            prompt += "a horror film, "
        case "Fantasy":
            prompt += "a fantasy film, "
        case "Thriller":
            prompt += "a thriller film, "
        case "Action":
            prompt += "an action film, "
        case "Drama":
            prompt += "a drama film, "
        default:
            prompt += "a film of any genre, "
        }
        
        switch requestModel.country {
        case "USA":
            prompt += "produced in USA "
        case "Great Britain":
            prompt += "produced in Great Britain "
        case "France":
            prompt += "produced in France "
        case "Russia":
            prompt += "produced in Russia "
        case "Italy":
            prompt += "produced in Italy "
        case "Japan":
            prompt += "produced in Japan "
        default:
            prompt += "produced in any country "
        }
        
        switch requestModel.director {
        case "Martin Scorsese":
            prompt += "and directed by Martin Scorsese "
        case "Quentin Tarantino":
            prompt += "and directed by Quentin Tarantino "
        case "Stanley Kubrick":
            prompt += "and directed by Stanley Kubrick "
        default:
            prompt += "and directed by any director "
        }
        
        switch requestModel.decade {
        case "2020s":
            prompt += "in 2020s."
        case "2010s":
            prompt += "in 2010s."
        case "2000s":
            prompt += "in 2000s."
        case "1990s":
            prompt += "in 1990s."
        case "1980s":
            prompt += "in 1980s."
        case "1970s":
            prompt += "in 1970s."
        case "1960s":
            prompt += "in 1960s."
        case "1950s":
            prompt += "in 1950s."
        case "1940s":
            prompt += "in 1940s."
        case "1930s":
            prompt += "in 1930s."
        default:
            prompt += "in any decade."
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

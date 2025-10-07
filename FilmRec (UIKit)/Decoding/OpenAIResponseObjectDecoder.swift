//
//  OpenAIResponseObjectDecoder.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 19.04.2025.
//

import Foundation

final class OpenAIResponseObjectDecoder {
    static let shared = OpenAIResponseObjectDecoder()
    
    private let openAIService = OpenAIService.shared
    
    private init() { }
    
    func decodeOpenAIResponse(from data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(OpenAIResponseObject.self, from: data)
            guard let responseText = self.getResponseText(from: decodedResponse) else {
                print("[OpenAIResponseObjectDecoder] - decodeOpenAIResponse: Something is wrong with response.")
                return nil
            }
            
            return responseText
        } catch {
            print("[OpenAIResponseObjectDecoder] - decodeOpenAIResponse: Error decoding Open AI response object.")
            return nil
        }
    }
    
    private func getResponseText(from response: OpenAIResponseObject) -> String? {
        guard let output = response.output else {
            print("[OpenAIResponseObjectDecoder] - getResponseText: No output was found.")
            return nil
        }
        
        var resultText = ""
        
        for message in output {
            guard let contents = message.content else {
                print("[OpenAIResponseObjectDecoder] - getResponseText: No content was found.")
                return nil
            }
            
            for messageContent in contents {
                if messageContent.type == "output_text", let text = messageContent.text {
                    resultText += text + " "
                }
            }
        }
        
        return resultText
    }
}

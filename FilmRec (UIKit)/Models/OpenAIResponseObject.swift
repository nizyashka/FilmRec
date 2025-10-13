import Foundation

struct OpenAIResponseObject: Codable {
    let output: [Message]?
}

struct Message: Codable {
    let content: [MessageContent]?
}

struct MessageContent: Codable {
    let type: String
    let text: String?
}

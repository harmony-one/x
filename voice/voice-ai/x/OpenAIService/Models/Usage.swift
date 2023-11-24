import Foundation
struct Usage: Codable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        promptTokens = try values.decodeIfPresent(Int.self, forKey: .promptTokens)
        completionTokens = try values.decodeIfPresent(Int.self, forKey: .completionTokens)
        totalTokens = try values.decodeIfPresent(Int.self, forKey: .totalTokens)
    }
}

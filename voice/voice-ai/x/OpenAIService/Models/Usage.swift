import Foundation
struct Usage: Codable {
    let prompt_tokens: Int?
    let completion_tokens: Int?
    let total_tokens: Int?

    enum CodingKeys: String, CodingKey {
        case prompt_tokens
        case completion_tokens
        case total_tokens
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt_tokens = try values.decodeIfPresent(Int.self, forKey: .prompt_tokens)
        completion_tokens = try values.decodeIfPresent(Int.self, forKey: .completion_tokens)
        total_tokens = try values.decodeIfPresent(Int.self, forKey: .total_tokens)
    }
}

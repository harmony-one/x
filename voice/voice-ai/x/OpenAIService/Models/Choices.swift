import Foundation
struct Choices: Codable {
    let index: Int?
    let message: Message?
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        message = try values.decodeIfPresent(Message.self, forKey: .message)
        finishReason = try values.decodeIfPresent(String.self, forKey: .finishReason)
    }
}

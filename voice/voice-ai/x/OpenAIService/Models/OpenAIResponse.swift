import Foundation
struct OpenAIResponse: Codable {
    let id: String?
    let object: String?
    let created: Int?
    let model: String?
    let choices: [Choices]?
    let usage: Usage?

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        choices = try values.decodeIfPresent([Choices].self, forKey: .choices)
        usage = try values.decodeIfPresent(Usage.self, forKey: .usage)
    }
}

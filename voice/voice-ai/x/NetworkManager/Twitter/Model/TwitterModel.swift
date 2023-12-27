import Foundation
struct TwitterModel: Codable {
    let listId: String?
    let name: String?
    let id: String?
    let isActive: Bool?
    let createdAt: String?
    let text: String?

    enum CodingKeys: String, CodingKey {

        case listId
        case name
        case id
        case isActive
        case createdAt
        case text
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        listId = try values.decodeIfPresent(String.self, forKey: .listId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        text = try values.decodeIfPresent(String.self, forKey: .text)

    }

}

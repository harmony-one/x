import Foundation
struct Message: Codable {
    let role: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case role
        case content
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

    init(role: String?, content: String?) {
        self.role = role
        self.content = content
    }
}

import Foundation
struct User: Codable {
    let id: String?
    let deviceId: String?
    let appleId: String?
    let balance: Int?
    let createdAt: String?
    let updatedAt: String?
    let expirationDate: String?
    let isSubscriptionActive: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case deviceId
        case appleId
        case balance
        case createdAt
        case updatedAt
        case expirationDate
        case isSubscriptionActive
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        deviceId = try values.decodeIfPresent(String.self, forKey: .deviceId)
        appleId = try values.decodeIfPresent(String.self, forKey: .appleId)
        balance = try values.decodeIfPresent(Int.self, forKey: .balance)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        expirationDate = try values.decodeIfPresent(String.self, forKey: .expirationDate)
        isSubscriptionActive = try values.decodeIfPresent(Bool.self, forKey: .isSubscriptionActive)
    }
}

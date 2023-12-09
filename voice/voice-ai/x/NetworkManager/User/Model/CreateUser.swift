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
    let appVersion: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id
        case deviceId
        case appleId
        case balance
        case createdAt
        case updatedAt
        case expirationDate
        case isSubscriptionActive
        case appVersion
        case address
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
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
        address = try values.decodeIfPresent(String.self, forKey: .address)

    }
    
    init(id: String? = nil,
         deviceId: String? = nil,
         appleId: String? = nil,
         balance: Int? = nil,
         createdAt: String? = nil,
         updatedAt: String? = nil,
         expirationDate: String? = nil,
         isSubscriptionActive: Bool? = nil,
         appVersion: String? = nil,
         address: String? = nil) {
       self.id = id
       self.deviceId = deviceId
       self.appleId = appleId
       self.balance = balance
       self.createdAt = createdAt
       self.updatedAt = updatedAt
       self.expirationDate = expirationDate
       self.isSubscriptionActive = isSubscriptionActive
       self.appVersion = appVersion
       self.address = address
    }
}

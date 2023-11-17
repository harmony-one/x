

import Foundation
struct User : Codable {
	let id : String?
	let deviceId : String?
	let appleId : String?
	let balance : Int?
	let createdAt : String?
	let updatedAt : String?
    let expirationDate : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case deviceId = "deviceId"
		case appleId = "appleId"
		case balance = "balance"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
        case expirationDate = "expirationDate"
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

	}

}

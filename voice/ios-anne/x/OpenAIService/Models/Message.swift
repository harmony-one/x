//
//  Message.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation
struct Message : Codable {
	let role : String?
	let content : String?

	enum CodingKeys: String, CodingKey {

		case role = "role"
		case content = "content"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		role = try values.decodeIfPresent(String.self, forKey: .role)
		content = try values.decodeIfPresent(String.self, forKey: .content)
	}

}

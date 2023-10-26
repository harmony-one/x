//
//  OpenAIResponse.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation
struct OpenAIResponse : Codable {
	let id : String?
	let object : String?
	let created : Int?
	let model : String?
	let choices : [Choices]?
	let usage : Usage?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case object = "object"
		case created = "created"
		case model = "model"
		case choices = "choices"
		case usage = "usage"
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

//
//  Usage.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation
struct Usage : Codable {
    let prompt_tokens : Int?
    let completion_tokens : Int?
    let total_tokens : Int?

    enum CodingKeys: String, CodingKey {

        case prompt_tokens = "prompt_tokens"
        case completion_tokens = "completion_tokens"
        case total_tokens = "total_tokens"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt_tokens = try values.decodeIfPresent(Int.self, forKey: .prompt_tokens)
        completion_tokens = try values.decodeIfPresent(Int.self, forKey: .completion_tokens)
        total_tokens = try values.decodeIfPresent(Int.self, forKey: .total_tokens)
    }

}

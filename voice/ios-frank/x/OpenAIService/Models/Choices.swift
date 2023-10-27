//
//  Choices.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation
struct Choices : Codable {
    let index : Int?
    let message : Message?
    let finish_reason : String?

    enum CodingKeys: String, CodingKey {

        case index = "index"
        case message = "message"
        case finish_reason = "finish_reason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        message = try values.decodeIfPresent(Message.self, forKey: .message)
        finish_reason = try values.decodeIfPresent(String.self, forKey: .finish_reason)
    }

}

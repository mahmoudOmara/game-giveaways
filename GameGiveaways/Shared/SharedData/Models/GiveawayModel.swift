//
//  Welcome.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

struct GiveawayModel: Decodable {
    let id: Int
    let title, worth: String
    let thumbnail, image: String
    let description, instructions: String
    let openGiveawayURL: String
    let publishedDate, type, platforms, endDate: String
    let users: Int
    let status: String
    let gamerpowerURL, openGiveaway: String

    enum CodingKeys: String, CodingKey {
        case id, title, worth, thumbnail, image, description, instructions
        case openGiveawayURL = "open_giveaway_url"
        case publishedDate = "published_date"
        case type, platforms
        case endDate = "end_date"
        case users, status
        case gamerpowerURL = "gamerpower_url"
        case openGiveaway = "open_giveaway"
    }
}

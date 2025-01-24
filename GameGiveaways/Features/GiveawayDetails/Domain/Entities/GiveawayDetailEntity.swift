//
//  GiveawayDetailEntity.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Foundation

struct GiveawayDetailEntity {
    let id: Int
    let imageURL: URL?
    let title: String
    let isActive: Bool
    let openGiveawayURL: URL?
    let worth: String
    let usersCount: Int
    let type: String
    let platforms: String
    let endDate: Date?
    let description: String
}

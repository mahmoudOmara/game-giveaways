//
//  GiveawayEntity.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Foundation

struct GiveawayEntity: Identifiable {
    let id: Int
    let title: String
    let platforms: String
    let description: String
    let thumbnailURL: URL?
}

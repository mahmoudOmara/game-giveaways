//
//  MorePlatformsGiveawaysEntity.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

struct MorePlatformsGiveawaysEntity {
    let epicGames: [GiveawayEntity]
    let platformGiveaways: [String: [GiveawayEntity]]
    
    var isEmpty: Bool {
        return epicGames.isEmpty && platformGiveaways.allSatisfy { $0.value.isEmpty }
    }
}

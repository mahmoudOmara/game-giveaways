//
//  FilterGiveawaysUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//


protocol SearchGiveawaysUseCaseProtocol {
    func execute(giveaways: [GiveawayEntity], query: String) -> [GiveawayEntity]
}



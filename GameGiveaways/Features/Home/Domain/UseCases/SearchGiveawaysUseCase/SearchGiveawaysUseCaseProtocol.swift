//
//  FilterGiveawaysUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine

protocol SearchGiveawaysUseCaseProtocol {
    func execute(
        giveaways: [GiveawayEntity],
        query: String) -> AnyPublisher<[GiveawayEntity], Never>
}

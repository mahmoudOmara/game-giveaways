//
//  GetGiveawayDetailsUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine

protocol GetGiveawayDetailsUseCaseProtocol {
    func execute(giveawayID: Int) -> AnyPublisher<GiveawayDetailEntity, Error>
}

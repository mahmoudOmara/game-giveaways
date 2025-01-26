//
//  GetMoreGiveawaysUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine

protocol GetMoreGiveawaysUseCaseProtocol {
    func execute() -> AnyPublisher<MorePlatformsGiveawaysEntity, Error>
}

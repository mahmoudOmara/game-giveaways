//
//  GetGiveawaysByPlatformsUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine

protocol GetGiveawaysByPlatformsUseCaseProtocol {
    func execute(platforms: [String]) -> AnyPublisher<[String: [GiveawayEntity]], Error>
}

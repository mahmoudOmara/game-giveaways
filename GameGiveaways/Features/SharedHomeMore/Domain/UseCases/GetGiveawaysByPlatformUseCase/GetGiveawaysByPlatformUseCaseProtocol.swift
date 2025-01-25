//
//  GetGiveawaysByPlatformUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GetGiveawaysByPlatformUseCaseProtocol {
    func execute(platform: String) -> AnyPublisher<[GiveawayEntity], Error>
}

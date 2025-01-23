//
//  GiveawaysRepositoryProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GiveawaysRepositoryProtocol {
    func getAllGiveaways() -> AnyPublisher<[GiveawayEntity], Error>
    func getGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayEntity], Error>
}

//
//  GiveawaysRemoteDataSourceProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GiveawaysRemoteDataSourceProtocol {
    func fetchAllGiveaways() -> AnyPublisher<[GiveawayModel], Error>
    func fetchGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayModel], Error>
}

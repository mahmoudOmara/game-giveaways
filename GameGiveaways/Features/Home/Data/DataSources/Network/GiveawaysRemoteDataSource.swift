//
//  GiveawaysRemoteDataSource.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class GiveawaysRemoteDataSource: GiveawaysRemoteDataSourceProtocol {
    private let apiClient: ApiClientProtocol

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchAllGiveaways() -> AnyPublisher<[GiveawayModel], Error> {
        apiClient.request(GameGiveawaysAPI.getAllGiveaways)
    }

    func fetchGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayModel], Error> {
        apiClient.request(GameGiveawaysAPI.getGiveawaysByPlatform(platform: platform))
    }
}

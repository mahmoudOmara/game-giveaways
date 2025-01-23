//
//  GiveawaysRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class GiveawaysRepository: GiveawaysRepositoryProtocol {
    private let dataSource: GiveawaysRemoteDataSourceProtocol

    init(dataSource: GiveawaysRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    private func convertToDomain(_ model: GiveawayModel) -> GiveawayEntity {
        GiveawayEntity(id: model.id, title: model.title)
    }

    func getAllGiveaways() -> AnyPublisher<[GiveawayEntity], Error> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchAllGiveaways()
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }

    func getGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchGiveawaysByPlatform(platform: platform)
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }
}

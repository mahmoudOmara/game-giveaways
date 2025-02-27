//
//  PlatformRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class PlatformRepository: PlatformRepositoryProtocol {
    private let dataSource: PlatformsLocalDataSourceProtocol

    init(dataSource: PlatformsLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    private func convertToDomain(_ model: PlatformModel) -> PlatformEntity {
        PlatformEntity(
            displayName: model.displayName,
            name: model.queryValue
        )
    }
    
    func getMostPopularPlatforms() -> AnyPublisher<[PlatformEntity], Never> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchMostPopularPlatforms()
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }
    
    func getRemainingPlatforms() -> AnyPublisher<[PlatformEntity], Never> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchRemainingPlatforms()
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }
    
    func getFeaturedPlatform() -> AnyPublisher<PlatformEntity, Never> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchFeaturedPlatform()
            .map { self.convertToDomain($0) }
            .eraseToAnyPublisher()
    }
}

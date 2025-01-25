//
//  PlatformsLocalDataSourceProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol PlatformsLocalDataSourceProtocol {
    func fetchMostPopularPlatforms() -> AnyPublisher<[PlatformModel], Never>
    func fetchRemainingPlatforms() -> AnyPublisher<[PlatformModel], Never>
    func fetchFeaturedPlatform() -> AnyPublisher<PlatformModel, Never>
}

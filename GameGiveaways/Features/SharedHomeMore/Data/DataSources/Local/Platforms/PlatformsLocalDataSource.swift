//
//  PlatformsLocalDataSource.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine
    
class PlatformsLocalDataSource: PlatformsLocalDataSourceProtocol {
    
    func fetchMostPopularPlatforms() -> AnyPublisher<[PlatformModel], Never> {
        let platforms = [
            PlatformModel(displayName: "PC", queryValue: "pc"),
            PlatformModel(displayName: "Steam", queryValue: "steam"),
            PlatformModel(displayName: "iOS", queryValue: "ios"),
            PlatformModel(displayName: "Android", queryValue: "android")
        ]
        return Just(platforms).eraseToAnyPublisher()
    }
    
    func fetchRemainingPlatforms() -> AnyPublisher<[PlatformModel], Never> {
        let platforms = [
            PlatformModel(displayName: "Xbox One", queryValue: "xbox-one"),
            PlatformModel(displayName: "Xbox 360", queryValue: "xbox-360"),
            PlatformModel(displayName: "Nintendo Switch", queryValue: "switch"),
            PlatformModel(displayName: "DRM-Free", queryValue: "drm-free"),
            PlatformModel(displayName: "Itch.io", queryValue: "itchio"),
            PlatformModel(displayName: "Playstation 4", queryValue: "ps4"),
            PlatformModel(displayName: "Playstation 5", queryValue: "ps5"),
            PlatformModel(displayName: "Xbox Series X|S", queryValue: "xbox-series-xs")
        ]
        
        return Just(platforms).eraseToAnyPublisher()
    }
    
    func fetchFeaturedPlatform() -> AnyPublisher<PlatformModel, Never> {
        let platform = PlatformModel(displayName: "Epic Games Store", queryValue: "epic-games-store")
        return Just(platform).eraseToAnyPublisher()
    }
}

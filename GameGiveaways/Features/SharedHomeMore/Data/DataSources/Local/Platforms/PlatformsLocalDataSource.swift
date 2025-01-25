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
            PlatformModel(name: "PC"),
            PlatformModel(name: "Steam"),
            PlatformModel(name: "iOS"),
            PlatformModel(name: "Android")
        ]
        return Just(platforms).eraseToAnyPublisher()
    }
    
    func fetchRemainingPlatforms() -> AnyPublisher<[PlatformModel], Never> {
        let platforms = [
            PlatformModel(name: "Xbox One"),
            PlatformModel(name: "Xbox 360"),
            PlatformModel(name: "Nintendo Switch"),
            PlatformModel(name: "DRM-Free"),
            PlatformModel(name: "Itch.io"),
            PlatformModel(name: "Playstation 4"),
            PlatformModel(name: "Playstation 5"),
            PlatformModel(name: "Xbox Series X|S")
        ]
        
        return Just(platforms).eraseToAnyPublisher()
    }
    
    func fetchFeaturedPlatform() -> AnyPublisher<PlatformModel, Never> {
        let platform = PlatformModel(name: "Epic Games Store")
        return Just(platform).eraseToAnyPublisher()
    }
}

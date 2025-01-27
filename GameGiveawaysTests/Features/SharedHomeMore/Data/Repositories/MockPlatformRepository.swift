//
//  MockPlatformRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine
@testable import GameGiveaways

class MockPlatformRepository: PlatformRepositoryProtocol {
    var mockMostPopularPlatforms: [PlatformEntity] = [
        PlatformEntity(displayName: "PS4", name: "PS4"),
        PlatformEntity(displayName: "PS5", name: "PS5"),
        PlatformEntity(displayName: "Xbox One", name: "Xbox One")
    ]
    
    var mockRemainingPlatforms: [PlatformEntity] = [
        PlatformEntity(displayName: "Nintendo Switch", name: "Nintendo Switch"),
        PlatformEntity(displayName: "PC", name: "PC")
    ]
    
    var mockFeaturedPlatform: PlatformEntity = PlatformEntity(displayName: "Epic Games", name: "Epic Games")
    
    var shouldReturnError = false
    
    func getMostPopularPlatforms() -> AnyPublisher<[PlatformEntity], Never> {
        Just(mockMostPopularPlatforms)
            .eraseToAnyPublisher()
    }
    
    func getRemainingPlatforms() -> AnyPublisher<[PlatformEntity], Never> {
        Just(mockRemainingPlatforms)
            .eraseToAnyPublisher()
    }
    
    func getFeaturedPlatform() -> AnyPublisher<PlatformEntity, Never> {
        Just(mockFeaturedPlatform)
            .eraseToAnyPublisher()
    }
}

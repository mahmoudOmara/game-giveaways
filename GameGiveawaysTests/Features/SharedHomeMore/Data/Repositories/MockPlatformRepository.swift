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
        PlatformEntity(name: "PS4"),
        PlatformEntity(name: "PS5"),
        PlatformEntity(name: "Xbox One")
    ]
    
    var mockRemainingPlatforms: [PlatformEntity] = [
        PlatformEntity(name: "Nintendo Switch"),
        PlatformEntity(name: "PC")
    ]
    
    var mockFeaturedPlatform: PlatformEntity = PlatformEntity(name: "Epic Games")
    
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

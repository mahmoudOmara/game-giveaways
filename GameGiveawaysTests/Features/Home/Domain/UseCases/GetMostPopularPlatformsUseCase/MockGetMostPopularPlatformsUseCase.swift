//
//  MockGetMostPopularPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//


import Foundation
import Combine
@testable import GameGiveaways

class MockGetMostPopularPlatformsUseCase: GetMostPopularPlatformsUseCaseProtocol {
    
    func execute() -> AnyPublisher<[GameGiveaways.PlatformEntity], Never> {
        let platforms: [PlatformEntity] = [
            PlatformEntity(displayName: "PC", name: "PC"),
            PlatformEntity(displayName: "PlayStation", name: "PlayStation"),
            PlatformEntity(displayName: "Xbox", name: "Xbox")
        ]
        return Just(platforms)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}

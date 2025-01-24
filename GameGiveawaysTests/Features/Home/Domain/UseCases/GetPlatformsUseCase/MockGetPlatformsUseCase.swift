//
//  MockGetPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//


import Foundation
import Combine
@testable import GameGiveaways

class MockGetPlatformsUseCase: GetPlatformsUseCaseProtocol {
    
    func execute() -> AnyPublisher<[GameGiveaways.PlatformEntity], Never> {
        let platforms: [PlatformEntity] = [
            PlatformEntity(name: "PC"),
            PlatformEntity(name: "PlayStation"),
            PlatformEntity(name: "Xbox")
        ]
        return Just(platforms)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}

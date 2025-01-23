//
//  MockGetGiveawaysByPlatformUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Foundation
import Combine
@testable import GameGiveaways

class MockGetGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol {
    var shouldReturnError = false

    func execute(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        }

        let filteredGiveaways = [
            GiveawayEntity(
                id: 2,
                title: "Filtered Giveaway",
                platforms: platform,
                description: "Filtered giveaway description"
            )
        ]
        return Just(filteredGiveaways)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

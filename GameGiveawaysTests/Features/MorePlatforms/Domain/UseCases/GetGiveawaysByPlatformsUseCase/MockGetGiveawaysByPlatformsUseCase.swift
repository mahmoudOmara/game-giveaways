//
//  MockGetGiveawaysByPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine
import Foundation
@testable import GameGiveaways

class MockGetGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol {
     
    let mockGiveawaysByPlatforms: [String: [GiveawayEntity]] = [
        "PS4": [
            GiveawayEntity(id: 1, title: "PS4 Game 1", platforms: "PS4", description: "First PS4 game", thumbnailURL: nil),
            GiveawayEntity(id: 2, title: "PS4 Game 2", platforms: "PS4", description: "Second PS4 game", thumbnailURL: nil)
        ],
        "PS5": [
            GiveawayEntity(id: 3, title: "PS5 Game 1", platforms: "PS5", description: "First PS5 game", thumbnailURL: nil)
        ],
        "Xbox One": [
            GiveawayEntity(id: 4, title: "Xbox One Game 1", platforms: "Xbox One", description: "First Xbox game", thumbnailURL: nil)
        ],
        "Nintendo Switch": [
            GiveawayEntity(id: 5, title: "N S Game 1", platforms: "Nintendo Switch", description: "First N S game", thumbnailURL: nil),
            GiveawayEntity(id: 6, title: "N S Game 2", platforms: "Nintendo Switch", description: "Second N S game", thumbnailURL: nil)
        ],
        "PC": [
            GiveawayEntity(id: 7, title: "PC Game 1", platforms: "PC", description: "PC game", thumbnailURL: nil)
        ]
    ]

    var shouldReturnError = false

    func execute(platforms: [String]) -> AnyPublisher<[String: [GiveawayEntity]], Error> {
        if shouldReturnError {
            return Fail(error: NSError(
                domain: "MockErrorDomain",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Failed to fetch giveaways"]
            ))
            .eraseToAnyPublisher()
        } else {
            let filteredGiveaways = mockGiveawaysByPlatforms.filter { platforms.contains($0.key) }
            return Just(filteredGiveaways)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

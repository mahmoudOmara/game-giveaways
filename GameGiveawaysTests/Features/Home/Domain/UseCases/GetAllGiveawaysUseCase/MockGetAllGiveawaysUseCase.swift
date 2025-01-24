//
//  MockGetAllGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Foundation
import Combine
@testable import GameGiveaways

class MockGetAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol {
    var shouldReturnError = false

    func execute() -> AnyPublisher<[GiveawayEntity], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        }

        let giveaways = [
            GiveawayEntity(
                id: 1,
                title: "Test Giveaway",
                platforms: "PC",
                description: "Test description",
                thumbnailURL: URL(string: "test://test-thumbnail.jpg")
            )
        ]
        return Just(giveaways)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

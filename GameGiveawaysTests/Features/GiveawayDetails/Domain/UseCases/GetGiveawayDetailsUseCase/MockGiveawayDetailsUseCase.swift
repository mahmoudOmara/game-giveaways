//
//  MockGiveawayDetailsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine
import Foundation
@testable import GameGiveaways

class MockGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol {
    var shouldReturnError = false
    var mockGiveawayDetail: GiveawayDetailEntity?

    func execute(giveawayID: Int) -> AnyPublisher<GiveawayDetailEntity, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        } else if let giveawayDetail = mockGiveawayDetail {
            return Just(giveawayDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Giveaway not found"]))
                .eraseToAnyPublisher()
        }
    }
}

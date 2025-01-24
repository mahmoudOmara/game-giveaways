//
//  MockGetPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Foundation
import Combine
@testable import GameGiveaways

class MockGetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    
    func execute() -> AnyPublisher<UserEntity, Never> {
        let user: UserEntity = UserEntity(
            name: "Mahmoud",
            profileImageURL: URL(string: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg")
        )
        return Just(user)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}

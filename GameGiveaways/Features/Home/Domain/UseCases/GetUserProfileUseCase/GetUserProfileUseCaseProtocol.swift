//
//  GetUserProfileUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GetUserProfileUseCaseProtocol {
    func execute() -> AnyPublisher<UserEntity, Never>
}

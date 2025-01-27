//
//  UserRepositoryProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol UserRepositoryProtocol {
    func getUserProfile() -> AnyPublisher<UserEntity, Never>
}

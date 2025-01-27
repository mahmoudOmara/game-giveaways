//
//  UserRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Foundation
import Combine

class UserRepository: UserRepositoryProtocol {
    private let dataSource: UserLocalDataSourceProtocol

    init(dataSource: UserLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    private func convertToDomain(_ model: UserModel) -> UserEntity {
        UserEntity(
            name: model.name,
            profileImageURL: URL(string: model.profileImageURL)
        )
    }

    func getUserProfile() -> AnyPublisher<UserEntity, Never> {
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchUserProfile()
            .map { self.convertToDomain($0) }
            .eraseToAnyPublisher()
    }
}

//
//  UserLocalDataSource.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class UserLocalDataSource: UserLocalDataSourceProtocol {
    func fetchUserProfile() -> AnyPublisher<UserModel, Never> {
        let user = UserModel(name: "Omara", profileImageURL: "https://example.com/profile.png")
        return Just(user).eraseToAnyPublisher()
    }
}

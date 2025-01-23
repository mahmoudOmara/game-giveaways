//
//  UserLocalDataSource 2.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol UserLocalDataSourceProtocol {
    func fetchUserProfile() -> AnyPublisher<UserModel, Never>
}

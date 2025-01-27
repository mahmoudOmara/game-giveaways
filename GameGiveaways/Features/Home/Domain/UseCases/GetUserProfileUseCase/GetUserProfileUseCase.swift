//
//  GetUserProfileUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<UserEntity, Never> {
        repository.getUserProfile()
    }
}

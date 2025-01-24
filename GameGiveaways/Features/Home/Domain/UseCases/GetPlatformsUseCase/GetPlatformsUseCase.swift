//
//  GetPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class GetPlatformsUseCase: GetPlatformsUseCaseProtocol {
    private let repository: PlatformRepositoryProtocol

    init(repository: PlatformRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[PlatformEntity], Never> {
        repository.getPlatforms()
    }
}

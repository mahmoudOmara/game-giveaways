//
//  GetGiveawaysByPlatformUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Combine

class GetGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol {
    private let repository: GiveawaysRepositoryProtocol

    init(repository: GiveawaysRepositoryProtocol) {
        self.repository = repository
    }

    func execute(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
        return repository.getGiveawaysByPlatform(platform: platform)
    }
}
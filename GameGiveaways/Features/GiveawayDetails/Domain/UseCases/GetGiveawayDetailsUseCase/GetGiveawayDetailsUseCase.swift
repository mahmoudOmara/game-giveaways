//
//  GetGiveawayDetailsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine

class GetGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol {
    private let repository: GiveawaysRepositoryProtocol

    init(repository: GiveawaysRepositoryProtocol) {
        self.repository = repository
    }

    func execute(giveawayID: Int) -> AnyPublisher<GiveawayDetailEntity, Error> {
        repository.getDetailedGiveawayByID(giveawayID)
    }
}

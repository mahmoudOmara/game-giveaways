//
//  GetAllGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Combine

class GetAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol {
    private let repository: GiveawaysRepositoryProtocol

    init(repository: GiveawaysRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[GiveawayEntity], Error> {
        return repository.getAllGiveaways()
    }
}
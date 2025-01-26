//
//  IsFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

protocol IsFavoriteUseCaseProtocol {
    func execute(giveawayID: Int) -> Bool
}

class IsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(giveawayID: Int) -> Bool {
        repository.isFavorite(id: giveawayID)
    }
}

//
//  RemoveFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

protocol RemoveFavoriteUseCaseProtocol {
    func execute(giveawayID: Int)
}

class RemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(giveawayID: Int) {
        repository.removeFavorite(id: giveawayID)
    }
}

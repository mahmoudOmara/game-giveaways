//
//  AddFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

protocol AddFavoriteUseCaseProtocol {
    func execute(giveawayID: Int)
}

class AddFavoriteUseCase: AddFavoriteUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(giveawayID: Int) {
        repository.addFavorite(id: giveawayID)
    }
}

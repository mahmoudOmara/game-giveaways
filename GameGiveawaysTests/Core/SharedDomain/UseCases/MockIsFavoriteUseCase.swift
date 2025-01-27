//
//  MockIsFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

@testable import GameGiveaways

class MockIsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    var favoriteGiveaways: Set<Int> = []
    
    func execute(giveawayID: Int) -> Bool {
        return favoriteGiveaways.contains(giveawayID)
    }
}

//
//  MockRemoveFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

@testable import GameGiveaways

class MockRemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol {
    var isExecuted = false
    var removedGiveawayID: Int?
    
    func execute(giveawayID: Int) {
        isExecuted = true
        removedGiveawayID = giveawayID
    }
}

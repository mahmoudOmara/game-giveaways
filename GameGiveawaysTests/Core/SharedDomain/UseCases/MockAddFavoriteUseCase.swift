//
//  MockAddFavoriteUseCase.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

@testable import GameGiveaways

class MockAddFavoriteUseCase: AddFavoriteUseCaseProtocol {
    var isExecuted = false
    var addedGiveawayID: Int?
    
    func execute(giveawayID: Int) {
        isExecuted = true
        addedGiveawayID = giveawayID
    }
}

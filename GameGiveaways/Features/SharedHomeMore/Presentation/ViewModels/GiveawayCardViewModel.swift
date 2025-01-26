//
//  GiveawayCardViewModel.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUI

class GiveawayCardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isFavorited: Bool
    
    // MARK: - Dependencies
    let giveaway: GiveawayEntity
    private let addFavoriteUseCase: AddFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    private let isFavoriteUseCase: IsFavoriteUseCaseProtocol
    
    // MARK: - Initializer
    init(
        giveaway: GiveawayEntity,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol
    ) {
        self.giveaway = giveaway
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        
        self.isFavorited = false
        checkIfFavorite()
    }
    
    // MARK: - Public Methods
    func toggleFavorite() {
        if isFavorited {
            removeFavorite()
        } else {
            addFavorite()
        }
        checkIfFavorite()
    }
    
    // MARK: - Private Methods
    private func checkIfFavorite() {
        isFavorited = isFavoriteUseCase.execute(giveawayID: giveaway.id)
    }
    
    private func addFavorite() {
        addFavoriteUseCase.execute(giveawayID: giveaway.id)
    }
    
    private func removeFavorite() {
        removeFavoriteUseCase.execute(giveawayID: giveaway.id)
    }
}

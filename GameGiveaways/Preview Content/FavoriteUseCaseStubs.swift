//
//  FavoriteUseCaseStubs.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

#if DEBUG
import Foundation
import Combine
import SwiftUI

class FavoriteUseCaseStubs {
    
    private static var favoriteIDs = Set<Int>()
    
    class AddFavoriteUseCaseStub: AddFavoriteUseCaseProtocol {
        func execute(giveawayID: Int) {
            FavoriteUseCaseStubs.favoriteIDs.insert(giveawayID)
        }
    }
    
    class RemoveFavoriteUseCaseStub: RemoveFavoriteUseCaseProtocol {
        func execute(giveawayID: Int) {
            FavoriteUseCaseStubs.favoriteIDs.remove(giveawayID)
        }
    }
    
    class IsFavoriteUseCaseStub: IsFavoriteUseCaseProtocol {
        func execute(giveawayID: Int) -> Bool {
            return FavoriteUseCaseStubs.favoriteIDs.contains(giveawayID)
        }
    }
    
    static func resetFavorites() {
        favoriteIDs.removeAll()
    }
    
    static func addInitialFavorites(_ ids: [Int]) {
        favoriteIDs = Set(ids)
    }
}
#endif

//
//  FavoritesLocalDataSource.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import Foundation

class FavoritesLocalDataSource: FavoritesLocalDataSourceProtocol {
    private let favoritesKey = "favoriteGiveaways"
    private let storage = UserDefaults.standard

    func addFavorite(_ id: Int) {
        var favorites = storage.array(forKey: favoritesKey) as? [Int] ?? []
        if !favorites.contains(id) {
            favorites.append(id)
            storage.set(favorites, forKey: favoritesKey)
        }
    }

    func removeFavorite(_ id: Int) {
        var favorites = storage.array(forKey: favoritesKey) as? [Int] ?? []
        favorites.removeAll { $0 == id }
        storage.set(favorites, forKey: favoritesKey)
    }

    func isFavorite(_ id: Int) -> Bool {
        let favorites = storage.array(forKey: favoritesKey) as? [Int] ?? []
        return favorites.contains(id)
    }
}

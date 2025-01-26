//
//  FavoritesLocalDataSourceProtocol.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

protocol FavoritesLocalDataSourceProtocol {
    func addFavorite(_ id: Int)
    func removeFavorite(_ id: Int)
    func isFavorite(_ id: Int) -> Bool
}

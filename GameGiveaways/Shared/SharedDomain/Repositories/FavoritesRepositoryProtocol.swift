//
//  FavoritesRepositoryProtocol.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

protocol FavoritesRepositoryProtocol {
    func addFavorite(id: Int)
    func removeFavorite(id: Int)
    func isFavorite(id: Int) -> Bool
}

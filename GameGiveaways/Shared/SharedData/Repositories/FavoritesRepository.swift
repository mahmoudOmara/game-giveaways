//
//  FavoritesRepository.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

class FavoritesRepository: FavoritesRepositoryProtocol {
    private let dataSource: FavoritesLocalDataSourceProtocol

    init(dataSource: FavoritesLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func addFavorite(id: Int) {
        dataSource.addFavorite(id)
    }

    func removeFavorite(id: Int) {
        dataSource.removeFavorite(id)
    }

    func isFavorite(id: Int) -> Bool {
        dataSource.isFavorite(id)
    }
}

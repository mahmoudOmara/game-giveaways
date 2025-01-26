//
//  GiveawayDetailsViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI

struct GiveawayDetailsViewFactory {
    static func createGiveawayDetailsView(giveawayID: Int, coordinator: GiveawayDetailsCoordinatorProtocol) -> some View {
        let favoritesLocalDataSource = FavoritesLocalDataSource()

        let giveawaysRepository = SharedFactory.getSharedGiveawaysRepository()
        let favoritesRepository = FavoritesRepository(dataSource: favoritesLocalDataSource)

        let getGiveawayDetailsUseCase = GetGiveawayDetailsUseCase(repository: giveawaysRepository)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: favoritesRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: favoritesRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
        
        let viewModel = GiveawayDetailsViewModel(
            giveawayID: giveawayID,
            getGiveawayDetailsUseCase: getGiveawayDetailsUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            coordinator: coordinator)
        
        let view = GiveawayDetailsView(viewModel: viewModel)
        return view
    }
    
    static func createGiveawayWebView(url: URL) -> some View {
        GiveawayWebView(url: url)
    }
}

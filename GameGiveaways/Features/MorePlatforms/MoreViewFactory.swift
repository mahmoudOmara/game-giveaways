//
//  MoreViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUICore

struct MoreViewFactory {
    static func createMoreView(coordinator: MorePlatformsCoordinatorProtocol) -> some View {
        let apiClient = ApiClient()
        
        let giveawaysRemoteDataSource = GiveawaysRemoteDataSource(apiClient: apiClient)
        let platformsLocalDataSource = PlatformsLocalDataSource()
        let favoritesLocalDataSource = FavoritesLocalDataSource()

        let giveawaysRepository = GiveawaysRepository(dataSource: giveawaysRemoteDataSource)
        let platformRepository = PlatformRepository(dataSource: platformsLocalDataSource)
        let favoritesRepository = FavoritesRepository(dataSource: favoritesLocalDataSource)
        
        let getGiveawaysByPlatformUseCase = GetGiveawaysByPlatformUseCase(repository: giveawaysRepository)
        let getGiveawaysByPlatformsUseCase = GetGiveawaysByPlatformsUseCase(
            getGiveawaysByPlatformUseCase: getGiveawaysByPlatformUseCase)
        
        let getMoreGiveawaysUseCase = GetMoreGiveawaysUseCase(
            platformRepository: platformRepository,
            getGiveawaysByPlatformUseCase: getGiveawaysByPlatformUseCase,
            getGiveawaysByPlatformsUseCase: getGiveawaysByPlatformsUseCase)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: favoritesRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: favoritesRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
        
        let viewModel = MoreViewModel(
            getMoreGiveawaysUseCase: getMoreGiveawaysUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            coordinator: coordinator)
        
        let view = MoreView(viewModel: viewModel)
        return view
    }
}

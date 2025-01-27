//
//  HomeViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct HomeViewFactory {
    static func createHomeView(coordinator: HomeCoordinatorProtocol) -> some View {
        let userLocalDataSource = UserLocalDataSource()
        let platformsLocalDataSource = PlatformsLocalDataSource()
        let favoritesLocalDataSource = FavoritesLocalDataSource()
        
        let userRepository = UserRepository(dataSource: userLocalDataSource)
        let platformRepository = PlatformRepository(dataSource: platformsLocalDataSource)
        let giveawaysRepository = SharedFactory.getSharedGiveawaysRepository()
        let favoritesRepository = FavoritesRepository(dataSource: favoritesLocalDataSource)
        
        let getUserProfileUseCase = GetUserProfileUseCase(repository: userRepository)
        let getMostPopularPlatformsUseCase = GetMostPopularPlatformsUseCase(repository: platformRepository)
        let getAllGiveawaysUseCase = GetAllGiveawaysUseCase(repository: giveawaysRepository)
        let getGiveawaysByPlatformUseCase = GetGiveawaysByPlatformUseCase(repository: giveawaysRepository)
        let searchGiveawaysUseCase = SearchGiveawaysUseCase()
        let addFavoriteUseCase = AddFavoriteUseCase(repository: favoritesRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: favoritesRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
        
        let viewModel = HomeViewModel(
            getUserProfileUseCase: getUserProfileUseCase,
            getMostPopularPlatformsUseCase: getMostPopularPlatformsUseCase,
            getAllGiveawaysUseCase: getAllGiveawaysUseCase,
            getFilteredGiveawaysUseCase: getGiveawaysByPlatformUseCase,
            searchGiveawaysUseCase: searchGiveawaysUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            coordinator: coordinator)
        
        let view = HomeView(viewModel: viewModel)
        return view
    }
    
    static func createHomeCoordinatorView() -> some View {
        let navigationController = UINavigationController()
        
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        
        return HomeCoordinatorView(coordinator: homeCoordinator)
    }
}

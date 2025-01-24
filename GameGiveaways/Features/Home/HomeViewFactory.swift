//
//  HomeViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct HomeViewFactory {
    static func createHomeView(coordinator: HomeCoordinatorProtocol) -> some View {
        let apiClient = ApiClient()
        
        let userLocalDataSource = UserLocalDataSource()
        let platformsLocalDataSource = PlatformsLocalDataSource()
        let giveawaysRemoteDataSource = GiveawaysRemoteDataSource(apiClient: apiClient)
        
        let userRepository = UserRepository(dataSource: userLocalDataSource)
        let platformRepository = PlatformRepository(dataSource: platformsLocalDataSource)
        let giveawaysRepository = GiveawaysRepository(dataSource: giveawaysRemoteDataSource)
        
        let getUserProfileUseCase = GetUserProfileUseCase(repository: userRepository)
        let getPlatformsUseCase = GetPlatformsUseCase(repository: platformRepository)
        let getAllGiveawaysUseCase = GetAllGiveawaysUseCase(repository: giveawaysRepository)
        let getGiveawaysByPlatformUseCase = GetGiveawaysByPlatformUseCase(repository: giveawaysRepository)
        let searchGiveawaysUseCase = SearchGiveawaysUseCase()
        
        let viewModel = HomeViewModel(
            getUserProfileUseCase: getUserProfileUseCase,
            getPlatformsUseCase: getPlatformsUseCase,
            getAllGiveawaysUseCase: getAllGiveawaysUseCase,
            getFilteredGiveawaysUseCase: getGiveawaysByPlatformUseCase,
            searchGiveawaysUseCase: searchGiveawaysUseCase,
            coordinator: coordinator)
        
        let view = HomeView(viewModel: viewModel)
        return view
    }
}

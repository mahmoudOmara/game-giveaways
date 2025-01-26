//
//  MoreViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUICore

struct MoreViewFactory {
    static func createMoreView(coordinator: MorePlatformsCoordinatorProtocol) -> some View {
        let giveawaysRepository = SharedFactory.getSharedGiveawaysRepository()
        let platformsLocalDataSource = PlatformsLocalDataSource()

        let platformRepository = PlatformRepository(dataSource: platformsLocalDataSource)
        let getGiveawaysByPlatformUseCase = GetGiveawaysByPlatformUseCase(repository: giveawaysRepository)
        let getGiveawaysByPlatformsUseCase = GetGiveawaysByPlatformsUseCase(
            getGiveawaysByPlatformUseCase: getGiveawaysByPlatformUseCase)
        
        let getMoreGiveawaysUseCase = GetMoreGiveawaysUseCase(
            platformRepository: platformRepository,
            getGiveawaysByPlatformUseCase: getGiveawaysByPlatformUseCase,
            getGiveawaysByPlatformsUseCase: getGiveawaysByPlatformsUseCase)
        
        let viewModel = MoreViewModel(
            getMoreGiveawaysUseCase: getMoreGiveawaysUseCase,
            coordinator: coordinator)
        
        let view = MoreView(viewModel: viewModel)
        return view
    }
}

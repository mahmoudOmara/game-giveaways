//
//  GiveawayDetailsViewFactory.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI

struct GiveawayDetailsViewFactory {
    static func createGiveawayDetailsView(giveawayID: Int, coordinator: GiveawayDetailsCoordinatorProtocol) -> some View {
        let giveawaysRepository = SharedFactory.getSharedGiveawaysRepository()

        let getGiveawayDetailsUseCase = GetGiveawayDetailsUseCase(repository: giveawaysRepository)
        
        let viewModel = GiveawayDetailsViewModel(giveawayID: giveawayID, getGiveawayDetailsUseCase: getGiveawayDetailsUseCase)
        
        let view = GiveawayDetailsView(viewModel: viewModel)
        return view
    }
}

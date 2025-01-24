//
//  HomeCoordinator.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

protocol HomeCoordinatorProtocol {
    func start()
    func navigateToDetail(giveaway: GiveawayEntity)
}

class HomeCoordinator: HomeCoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeView = HomeViewFactory.createHomeView()
        let hostingController = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func navigateToDetail(giveaway: GiveawayEntity) {
        
    }
}

//
//  HomeCoordinator.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

protocol HomeCoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
    func navigateToDetail(giveawayID: Int)
    func navigateToMorePlatforms()
}

class HomeCoordinator: HomeCoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeView = HomeViewFactory.createHomeView(coordinator: self)
        let hostingController = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func navigateToDetail(giveawayID: Int) {
        let detailsCoordinator = GiveawayDetailsCoordinator(navigationController: navigationController, giveawayID: giveawayID)
        detailsCoordinator.start()
    }
    
    func navigateToMorePlatforms() {
        let morePlatformsCoordinator = MorePlatformsCoordinator(navigationController: navigationController)
        morePlatformsCoordinator.start()
    }
}

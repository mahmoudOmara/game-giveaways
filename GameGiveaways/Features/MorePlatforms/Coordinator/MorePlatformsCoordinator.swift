//
//  MorePlatformsCoordinator.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUI

protocol MorePlatformsCoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
    func navigateToDetail(giveawayID: Int)
}

class MorePlatformsCoordinator: MorePlatformsCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let morePlatformsView = MoreViewFactory.createMoreView(coordinator: self)
        let hostingController = UIHostingController(rootView: morePlatformsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func navigateToDetail(giveawayID: Int) {
        let detailsCoordinator = GiveawayDetailsCoordinator(navigationController: navigationController, giveawayID: giveawayID)
        detailsCoordinator.start()
    }
}

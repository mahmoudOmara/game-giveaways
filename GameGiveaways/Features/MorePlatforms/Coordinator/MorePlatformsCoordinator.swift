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
    func back()
}

class MorePlatformsCoordinator: MorePlatformsCoordinatorProtocol {
    var navigationController: UINavigationController
    let giveawayID: Int
    
    init(navigationController: UINavigationController, giveawayID: Int) {
        self.navigationController = navigationController
        self.giveawayID = giveawayID
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

    func back() {
        navigationController.popViewController(animated: true)
    }
}

//
//  GiveawayDetailsCoordinator.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI
import WebKit

protocol GiveawayDetailsCoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
    func navigateToGiveawayWebView(with: URL)
    func back()
}

class GiveawayDetailsCoordinator: GiveawayDetailsCoordinatorProtocol {
    var navigationController: UINavigationController
    let giveawayID: Int
    
    init(navigationController: UINavigationController, giveawayID: Int) {
        self.navigationController = navigationController
        self.giveawayID = giveawayID
    }

    func start() {
        let giveawayDetailsView = GiveawayDetailsViewFactory.createGiveawayDetailsView(giveawayID: giveawayID, coordinator: self)
        let hostingController = UIHostingController(rootView: giveawayDetailsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func navigateToGiveawayWebView(with url: URL) {
        let webView = GiveawayDetailsViewFactory.createGiveawayWebView(url: url)
        let hostingController = UIHostingController(rootView: webView)
        navigationController.present(hostingController, animated: true)
    }

    func back() {
        navigationController.popViewController(animated: true)
    }
}

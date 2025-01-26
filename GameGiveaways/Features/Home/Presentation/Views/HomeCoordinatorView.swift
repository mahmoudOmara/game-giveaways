//
//  HomeCoordinatorView.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct HomeCoordinatorView: UIViewControllerRepresentable {
    let coordinator: HomeCoordinatorProtocol

    func makeUIViewController(context: Context) -> UINavigationController {
        coordinator.start()
        return coordinator.navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates required for now
    }
}

//
//  GameGiveawaysApp.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI

@main
struct GameGiveawaysApp: App {
    var body: some Scene {
        WindowGroup {
            HomeViewFactory.createHomeCoordinatorView()
        }
    }
}

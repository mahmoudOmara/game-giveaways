//
//  PlatformsLocalDataSource.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

class PlatformsLocalDataSource: PlatformsLocalDataSourceProtocol {
    func fetchPlatforms() -> AnyPublisher<[PlatformModel], Never> {
        let platforms = [
            PlatformModel(name: "pc"),
            PlatformModel(name: "steam"),
            PlatformModel(name: "ios"),
            PlatformModel(name: "android")
        ]
        return Just(platforms).eraseToAnyPublisher()
    }
}

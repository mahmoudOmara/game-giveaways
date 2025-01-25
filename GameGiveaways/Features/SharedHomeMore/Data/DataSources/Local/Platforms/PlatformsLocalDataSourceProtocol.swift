//
//  PlatformsLocalDataSourceProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol PlatformsLocalDataSourceProtocol {
    func fetchPlatforms() -> AnyPublisher<[PlatformModel], Never>
}

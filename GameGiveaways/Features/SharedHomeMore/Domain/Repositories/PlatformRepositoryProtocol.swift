//
//  PlatformRepositoryProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol PlatformRepositoryProtocol {
    func getMostPopularPlatforms() -> AnyPublisher<[PlatformEntity], Never>
}

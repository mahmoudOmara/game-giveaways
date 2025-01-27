//
//  GetMostPopularPlatformsUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GetMostPopularPlatformsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlatformEntity], Never>
}

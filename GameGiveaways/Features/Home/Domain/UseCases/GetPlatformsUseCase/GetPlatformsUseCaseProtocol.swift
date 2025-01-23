//
//  GetPlatformsUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GetPlatformsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlatformEntity], Never>
}

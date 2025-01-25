//
//  GetGiveawaysByPlatformsUseCase.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine

protocol GetGiveawaysByPlatformsUseCaseProtocol {
    func execute(platforms: [String]) -> AnyPublisher<[String: [GiveawayEntity]], Error>
}

class GetGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol {
    private let getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol

    init(getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol) {
        self.getGiveawaysByPlatformUseCase = getGiveawaysByPlatformUseCase
    }

    func execute(platforms: [String]) -> AnyPublisher<[String: [GiveawayEntity]], Error> {
        let publishers = platforms.map { platform in
            getGiveawaysByPlatformUseCase.execute(platform: platform)
                .map { (platform, $0) }
                .catch { _ in Just((platform, [])).setFailureType(to: Error.self)  }
        }

        return Publishers.MergeMany(publishers)
            .collect()
            .map { Dictionary(uniqueKeysWithValues: $0) }
            .eraseToAnyPublisher()
    }
}

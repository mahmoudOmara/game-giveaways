//
//  GetMoreGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine

class GetMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol {
    private let platformRepository: PlatformRepositoryProtocol
    private let getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol
    private let getGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol
    
    init(
        platformRepository: PlatformRepositoryProtocol,
        getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol,
        getGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol) {
            self.platformRepository = platformRepository
            self.getGiveawaysByPlatformUseCase = getGiveawaysByPlatformUseCase
            self.getGiveawaysByPlatformsUseCase = getGiveawaysByPlatformsUseCase
        }
    
    func execute() -> AnyPublisher<MorePlatformsGiveawaysEntity, Error> {
        return Publishers.CombineLatest(
            platformRepository.getFeaturedPlatform(),
            platformRepository.getRemainingPlatforms()
        )
        .flatMap { featuredPlatform, remainingPlatforms in
            let epicGamesPublisher = self.getGiveawaysByPlatformUseCase.execute(platform: featuredPlatform.name)
                .catch { _ in Just([]).setFailureType(to: Error.self) }
            
            let platformsPublisher = self.getGiveawaysByPlatformsUseCase.execute(platforms: remainingPlatforms.map { $0.name })
                .catch { _ in Just([:]).setFailureType(to: Error.self) }

            return Publishers.CombineLatest(epicGamesPublisher, platformsPublisher)
                .map { epicGamesGiveaways, platformGiveaways in
                    MorePlatformsGiveawaysEntity(
                        epicGames: epicGamesGiveaways,
                        platformGiveaways: platformGiveaways
                    )
                }
        }
        .eraseToAnyPublisher()
    }
}

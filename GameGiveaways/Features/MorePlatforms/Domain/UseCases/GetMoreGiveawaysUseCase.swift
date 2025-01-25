//
//  GetMoreGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import Combine

protocol GetMoreGiveawaysUseCaseProtocol {
    func execute() -> AnyPublisher<MorePlatformsGiveawaysEntity, Error>
}

class GetMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol {
    private let getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol
    private let getGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol
    
    private let platforms = ["PS4", "PS5", "Xbox One"]
    private let epicGamesPlatform = "Epic Games"
    
    init(
        getGiveawaysByPlatformUseCase: GetGiveawaysByPlatformUseCaseProtocol,
        getGiveawaysByPlatformsUseCase: GetGiveawaysByPlatformsUseCaseProtocol) {
            self.getGiveawaysByPlatformUseCase = getGiveawaysByPlatformUseCase
            self.getGiveawaysByPlatformsUseCase = getGiveawaysByPlatformsUseCase
        }
    
    func execute() -> AnyPublisher<MorePlatformsGiveawaysEntity, Error> {
        let epicGamesPublisher = getGiveawaysByPlatformUseCase.execute(platform: epicGamesPlatform)
            .catch { _ in Just([]).setFailureType(to: Error.self) }
        
        let platformsPublisher = getGiveawaysByPlatformsUseCase.execute(platforms: platforms)
        
        return Publishers.CombineLatest(epicGamesPublisher, platformsPublisher)
            .map { epicGamesGiveaways, platformGiveaways in
                MorePlatformsGiveawaysEntity(
                    epicGames: epicGamesGiveaways,
                    platformGiveaways: platformGiveaways
                )
            }
            .eraseToAnyPublisher()
    }
}

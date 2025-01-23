//
//  HomeFeatureStubs.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


#if DEBUG
import Combine

class HomeFeatureStubs {
    static let sampleGiveaways: [GiveawayEntity] = [
        GiveawayEntity(
            id: 1,
            title: "Free Steam Game",
            platforms: "PC",
            description: "A free giveaway for Steam users."
        ),
        GiveawayEntity(
            id: 2,
            title: "Free Xbox Game",
            platforms: "Xbox",
            description: "A free giveaway for Xbox users."
        )
    ]

    class GetAllGiveawaysUseCaseStub: GetAllGiveawaysUseCaseProtocol {
        func execute() -> AnyPublisher<[GiveawayEntity], Error> {
            Just(HomeFeatureStubs.sampleGiveaways)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    class GetGiveawaysByPlatformUseCaseStub: GetGiveawaysByPlatformUseCaseProtocol {
        func execute(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
            let filteredGiveaways = HomeFeatureStubs.sampleGiveaways.filter { $0.platforms == platform }
            return Just(filteredGiveaways)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
#endif

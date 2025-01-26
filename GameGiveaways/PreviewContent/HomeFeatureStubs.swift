//
//  HomeFeatureStubs.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

#if DEBUG
import Foundation
import Combine
import SwiftUI

class HomeFeatureStubs {
    static let sampleGiveaways: [GiveawayEntity] = [
        GiveawayEntity(
            id: 1,
            title: "Free Steam Game",
            platforms: "PC",
            description: "A free giveaway for Steam users.",
            thumbnailURL: URL(string: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg")
        ),
        GiveawayEntity(
            id: 2,
            title: "Free Xbox Game",
            platforms: "Xbox",
            description: "A free giveaway for Xbox users.",
            thumbnailURL: URL(string: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg")
        )
    ]
    
    static let sampleUser: UserEntity = UserEntity(
        name: "Mahmoud",
        profileImageURL: URL(string: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg")
    )
    
    static let samplePlatforms: [PlatformEntity] = [
        PlatformEntity(name: "PC"),
        PlatformEntity(name: "PlayStation"),
        PlatformEntity(name: "Xbox")
    ]
    
    class GetUserProfileUseCaseStub: GetUserProfileUseCaseProtocol {
        func execute() -> AnyPublisher<UserEntity, Never> {
            Just(HomeFeatureStubs.sampleUser)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
    }
    
    class GetMostPopularPlatformsUseCaseStub: GetMostPopularPlatformsUseCaseProtocol {
        func execute() -> AnyPublisher<[PlatformEntity], Never> {
            Just(HomeFeatureStubs.samplePlatforms)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
    }

    class GetAllGiveawaysUseCaseStub: GetAllGiveawaysUseCaseProtocol {
        func execute() -> AnyPublisher<[GiveawayEntity], Error> {
            Just(HomeFeatureStubs.sampleGiveaways)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    class GetGiveawaysByPlatformUseCaseStub: GetGiveawaysByPlatformUseCaseProtocol {
        func execute(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
            let filteredGiveaways = HomeFeatureStubs.sampleGiveaways.filter {
                $0.platforms == platform
            }
            return Just(filteredGiveaways)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class StubSearchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol {
        func execute(
            giveaways: [GiveawayEntity], query: String
        ) -> AnyPublisher<[GiveawayEntity], Never> {
            let filteredGiveaways = giveaways.filter {
                if query.isEmpty {
                    return true
                }
                return $0.title.lowercased().contains(query.lowercased())
            }
            return Just(filteredGiveaways).eraseToAnyPublisher()
        }
    }
    
    class StubHomeCoordinator: HomeCoordinatorProtocol {
        var navigationController: UINavigationController = UINavigationController()
        
        func start() {
            // No-op for previews
        }
        
        func navigateToDetail(giveawayID: Int) {
            print("Stub navigation to detail for giveaway ID: \(giveawayID)")
        }
        
        func navigateToMorePlatforms() {
            
        }
    }
}
#endif

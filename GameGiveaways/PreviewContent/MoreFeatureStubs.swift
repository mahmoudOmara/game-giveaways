//
//  MoreFeatureStubs.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

#if DEBUG
import Foundation
import Combine
import SwiftUI

class MoreFeatureStubs {
    static let epicGamesGiveaways = [
        GiveawayEntity(
            id: 1,
            title: "Escape Academy (Epic Games) Giveaway",
            platforms: "Epic Games",
            description: "Become the ultimate Escapist today!",
            thumbnailURL: URL(string: "https://example.com/epic1.jpg")
        ),
        GiveawayEntity(
            id: 2,
            title: "Fortnite: Special Pack",
            platforms: "Epic Games",
            description: "Unlock exclusive skins and V-Bucks for Fortnite!",
            thumbnailURL: URL(string: "https://example.com/epic2.jpg")
        ),
        GiveawayEntity(
            id: 3,
            title: "Rocket League: Season Pass",
            platforms: "Epic Games",
            description: "Get your hands on a free Rocket League Season Pass!",
            thumbnailURL: URL(string: "https://example.com/epic3.jpg")
        ),
        GiveawayEntity(
            id: 4,
            title: "GTA V Premium Edition Giveaway",
            platforms: "Epic Games",
            description: "Enjoy the ultimate open-world experience with GTA V!",
            thumbnailURL: URL(string: "https://example.com/epic4.jpg")
        ),
        GiveawayEntity(
            id: 5,
            title: "The Witcher 3: Wild Hunt",
            platforms: "Epic Games",
            description: "Dive into the legendary RPG adventure with Geralt of Rivia.",
            thumbnailURL: URL(string: "https://example.com/epic5.jpg")
        )
    ]
    
    static let ps4Giveaways = [
        GiveawayEntity(
            id: 2,
            title: "The Elder Scrolls Online: Experience Scroll Key Giveaway",
            platforms: "PS4", description: "Claim your free key!",
            thumbnailURL: URL(string: "https://example.com/ps41.jpg")),
        
        GiveawayEntity(
            id: 3,
            title: "Destiny 2 Emblem Key Giveaway",
            platforms: "PS4",
            description: "Get the emblem key for Destiny 2!",
            thumbnailURL: URL(string: "https://example.com/ps42.jpg"))
    ]
    
    static let ps5Giveaways = [
        GiveawayEntity(
            id: 4,
            title: "The Elder Scrolls Online: Experience Scroll Key Giveaway",
            platforms: "PS5",
            description: "Claim your free key!",
            thumbnailURL: URL(string: "https://example.com/ps51.jpg")),
        
        GiveawayEntity(
            id: 5,
            title: "Dead by Daylight Codes",
            platforms: "PS5",
            description: "Grab your codes!",
            thumbnailURL: URL(string: "https://example.com/ps52.jpg"))
    ]
    
    static let xboxGiveaways = [
        GiveawayEntity(
            id: 6,
            title: "The Elder Scrolls Online: Experience Scroll Key Giveaway",
            platforms: "Xbox One",
            description: "Claim your free key!",
            thumbnailURL: URL(string: "https://example.com/xbox1.jpg"))
    ]
    
    static let mockGiveaways: [String: [GiveawayEntity]] = [
        "Epic Games": epicGamesGiveaways,
        "PS4": ps4Giveaways,
        "PS5": ps5Giveaways,
        "Xbox One": xboxGiveaways
    ]
    
    class StubGetMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol {
        func execute() -> AnyPublisher<MorePlatformsGiveawaysEntity, Error> {
            let platforms = ["PS4", "PS5", "Xbox One"]
            let filteredPlatforms = mockGiveaways.reduce(into: [String: [GiveawayEntity]]()) { result, entry in
                if platforms.contains(entry.key) {
                    result[entry.key] = entry.value
                }
            }
            return Just(MorePlatformsGiveawaysEntity(epicGames: epicGamesGiveaways, platformGiveaways: filteredPlatforms))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class StubMorePlatformsCoordinator: MorePlatformsCoordinatorProtocol {
        var navigationController: UINavigationController = UINavigationController()
        
        func start() {

        }
        
        func navigateToDetail(giveawayID: Int) {
            
        }
        
        func back() {
            
        }
    }
}
#endif

//
//  MockApiClient.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Combine
import Moya
import Foundation
@testable import GameGiveaways

class MockGameGiveawaysApiClient: ApiClientProtocol {
    var shouldReturnError = false
    
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, Error> {
        if shouldReturnError {
            return Fail(
                error: NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Mock error"]
                )
            )
            .eraseToAnyPublisher()
        }
        
        if let apiTarget = target as? GameGiveawaysAPI {
            switch apiTarget {
            case .getAllGiveaways:
                return mockAllGiveawaysResponse()
            case .getGiveawaysByPlatform(let platform):
                return mockFilteredGiveawaysResponse(platform: platform)
            }
        }
        
        return Fail(
            error: NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid API Target"]
            )
        )
        .eraseToAnyPublisher()
    }
    
    private func mockAllGiveawaysResponse<T: Decodable>() -> AnyPublisher<T, Error> {
        let mockGiveaway = GiveawayModel(
            id: 1,
            title: "Romopolis (Microsoft Store) Giveaway",
            worth: "$4.99",
            thumbnail: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg",
            image: "https://www.gamerpower.com/offers/1b/6717d4efdd754.jpg",
            description: "Become an architect today! Download Romopolis for free on the Microsoft Store and start building your very own ancient Roman city! It's the ultimate casual sim for anyone who's ever thought, \"Hey, I could design Rome, how hard could it be?\"...",
            instructions: "1. Click the \"Get Giveaway\" button to visit the giveaway page.\r\n2. Login into your Microsoft Store account.\r\n3. Click the \"GET\" button to add the game to your library",
            openGiveawayURL: "https://www.gamerpower.com/open/romopolis-giveaway",
            publishedDate: "2025-01-22 20:45:36",
            type: "Game",
            platforms: "PC",
            endDate: "2025-01-26 23:59:00",
            users: 4110,
            status: "Active",
            gamerpowerURL: "https://www.gamerpower.com/romopolis-giveaway",
            openGiveaway: "https://www.gamerpower.com/open/romopolis-giveaway"
        )
        
        return Just([mockGiveaway] as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func mockFilteredGiveawaysResponse<T: Decodable>(platform: String) -> AnyPublisher<T, Error> {
        let mockGiveaway = GiveawayModel(
            id: 1,
            title: "Romopolis (Microsoft Store) Giveaway",
            worth: "$4.99",
            thumbnail: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg",
            image: "https://www.gamerpower.com/offers/1b/6717d4efdd754.jpg",
            description: "Become an architect today! Download Romopolis for free on the Microsoft Store and start building your very own ancient Roman city! It's the ultimate casual sim for anyone who's ever thought, \"Hey, I could design Rome, how hard could it be?\"...",
            instructions: "1. Click the \"Get Giveaway\" button to visit the giveaway page.\r\n2. Login into your Microsoft Store account.\r\n3. Click the \"GET\" button to add the game to your library",
            openGiveawayURL: "https://www.gamerpower.com/open/romopolis-giveaway",
            publishedDate: "2025-01-22 20:45:36",
            type: "Game",
            platforms: platform,
            endDate: "2025-01-26 23:59:00",
            users: 4110,
            status: "Active",
            gamerpowerURL: "https://www.gamerpower.com/romopolis-giveaway",
            openGiveaway: "https://www.gamerpower.com/open/romopolis-giveaway"
        )
        
        return Just([mockGiveaway] as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

//
//  MockGiveawaysRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import Foundation
import Combine
@testable import GameGiveaways

class MockGiveawaysRepository: GiveawaysRepositoryProtocol {
    var shouldReturnError = false
    
    func getAllGiveaways() -> AnyPublisher<[GiveawayEntity], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock repository error"]))
                .eraseToAnyPublisher()
        }
        
        let giveaways = [
            GiveawayEntity(
                id: 1,
                title: "Free Steam Game",
                platforms: "Test giveaway",
                description: "PC"
            )
        ]
        
        return Just(giveaways)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock repository error"]))
                .eraseToAnyPublisher()
        }
        
        let filteredGiveaways = [
            GiveawayEntity(
                id: 2,
                title: "Free Xbox Game",
                platforms: platform,
                description: "Filtered giveaway"
            )
        ]
        
        return Just(filteredGiveaways)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

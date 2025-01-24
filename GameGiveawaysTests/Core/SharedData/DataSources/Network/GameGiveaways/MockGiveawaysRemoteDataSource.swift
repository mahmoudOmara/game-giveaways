//
//  MockGiveawaysRemoteDataSource.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Foundation
import Combine
@testable import GameGiveaways

class MockGiveawaysRemoteDataSource: GiveawaysRemoteDataSourceProtocol {
    var shouldReturnError = false

    func fetchAllGiveaways() -> AnyPublisher<[GiveawayModel], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock data source error"]))
                .eraseToAnyPublisher()
        }

        let giveaway = GiveawayModel(
            id: 1,
            title: "Test Giveaway",
            worth: "$10",
            thumbnail: "https://example.com/thumbnail.jpg",
            image: "https://example.com/image.jpg",
            description: "Test description",
            instructions: "Test instructions",
            openGiveawayURL: "https://example.com/open_giveaway",
            publishedDate: "2025-01-01",
            type: "Game",
            platforms: "PC",
            endDate: "2025-12-31",
            users: 5000,
            status: "Active",
            gamerpowerURL: "https://example.com/gamerpower",
            openGiveaway: "https://example.com/open_giveaway"
        )

        return Just([giveaway])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayModel], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock data source error"]))
                .eraseToAnyPublisher()
        }

        let filteredGiveaway = GiveawayModel(
            id: 2,
            title: "Filtered Giveaway",
            worth: "$20",
            thumbnail: "https://example.com/thumbnail2.jpg",
            image: "https://example.com/image2.jpg",
            description: "Filtered giveaway description",
            instructions: "Filtered instructions",
            openGiveawayURL: "https://example.com/open_giveaway_filtered",
            publishedDate: "2025-02-01",
            type: "Game",
            platforms: platform,
            endDate: "2025-12-31",
            users: 10000,
            status: "Active",
            gamerpowerURL: "https://example.com/gamerpower_filtered",
            openGiveaway: "https://example.com/open_giveaway_filtered"
        )

        return Just([filteredGiveaway])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

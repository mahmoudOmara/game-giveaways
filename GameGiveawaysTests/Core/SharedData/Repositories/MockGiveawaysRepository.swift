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
    var storedGiveaways: [GiveawayModel] = []
    
    private func convertToDomain(_ model: GiveawayModel) -> GiveawayDetailEntity {
        return GiveawayDetailEntity(
            id: model.id,
            imageURL: URL(string: model.image),
            title: model.title,
            isActive: model.status.lowercased() == "active",
            openGiveawayURL: URL(string: model.openGiveaway),
            worth: model.worth,
            usersCount: model.users,
            type: model.type,
            platforms: model.platforms,
            endDate: Date.parse(from: model.endDate) ?? Date(),
            description: model.description
        )
    }
    
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
                description: "PC",
                thumbnailURL: URL(string: "test://test-thumbnail.jpg")
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
                description: "Filtered giveaway",
                thumbnailURL: URL(string: "test://test-thumbnail.jpg")
            )
        ]
        
        return Just(filteredGiveaways)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getDetailedGiveawayByID(_ id: Int) -> AnyPublisher<GiveawayDetailEntity, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Giveaway not found"]))
                .eraseToAnyPublisher()
        } else if let giveawayModel = storedGiveaways.first(where: { $0.id == id }) {
            let giveawayDetailEntity = convertToDomain(giveawayModel)
            return Just(giveawayDetailEntity)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Giveaway not found"]))
                .eraseToAnyPublisher()
        }
    }
}

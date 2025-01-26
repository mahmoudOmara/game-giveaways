//
//  GiveawaysRepository.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Foundation
import Combine

class GiveawaysRepository: GiveawaysRepositoryProtocol {
    private let dataSource: GiveawaysRemoteDataSourceProtocol

    private var storedGiveaways = [GiveawayModel]()
    
    init(dataSource: GiveawaysRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    private func convertToDomain(_ model: GiveawayModel) -> GiveawayEntity {
        GiveawayEntity(
            id: model.id,
            title: model.title,
            platforms: model.platforms,
            description: model.description,
            thumbnailURL: URL(string: model.thumbnail)
        )
    }
    
    private func convertToDomain(_ model: GiveawayModel) -> GiveawayDetailEntity {
        GiveawayDetailEntity(
            id: model.id,
            imageURL: URL(string: model.image),
            title: model.title,
            isActive: model.status.lowercased() == "active",
            openGiveawayURL: URL(string: model.openGiveaway),
            worth: model.worth,
            usersCount: model.users,
            type: model.type,
            platforms: model.platforms,
            endDate: Date.parse(from: model.endDate),
            description: model.description
        )
    }

    func getAllGiveaways() -> AnyPublisher<[GiveawayEntity], Error> {
        // this should assign storedGiveaways
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchAllGiveaways()
            .handleEvents(receiveOutput: { [weak self] giveaways in
                self?.storedGiveaways = giveaways
            })
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }

    func getGiveawaysByPlatform(platform: String) -> AnyPublisher<[GiveawayEntity], Error> {
        // this should assign storedGiveaways
        // No need to keep a weak reference of self as the map function will return immediately
        dataSource.fetchGiveawaysByPlatform(platform: platform)
            .handleEvents(receiveOutput: { [weak self] giveaways in
                self?.storedGiveaways = giveaways
            })
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }
    
    func getDetailedGiveawayByID(_ id: Int) -> AnyPublisher<GiveawayDetailEntity, Error> {
        
        if let giveawayModel = storedGiveaways.first(where: { $0.id == id }) {
            let giveawayDetailEntity: GiveawayDetailEntity = convertToDomain(giveawayModel)
            return Just(giveawayDetailEntity)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(
                domain: "GiveawayErrorDomain",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Giveaway not found"]))
                .eraseToAnyPublisher()
        }
    }
}

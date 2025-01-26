//
//  SharedFactory.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct SharedFactory {
    
    // Static lazy property ensures the repository is created only once when first accessed
    private static let giveawayRepository: GiveawaysRepositoryProtocol = {
        let apiClient = ApiClient()
        let giveawaysRemoteDataSource = GiveawaysRemoteDataSource(apiClient: apiClient)
        return GiveawaysRepository(dataSource: giveawaysRemoteDataSource)
    }()
    
    // Public method to return the shared instance of the repository
    static func getSharedGiveawaysRepository() -> GiveawaysRepositoryProtocol {
        return giveawayRepository
    }
}

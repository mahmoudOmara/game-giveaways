//
//  MockSearchGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine
@testable import GameGiveaways

class MockSearchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol {
    func execute(giveaways: [GiveawayEntity], query: String) -> AnyPublisher<[GiveawayEntity], Never> {
        let filteredGiveaways = giveaways.filter {
            if query.isEmpty {
                return true
            }
            return $0.title.lowercased().contains(query.lowercased())
        }
        return Just(filteredGiveaways).eraseToAnyPublisher()
    }
}

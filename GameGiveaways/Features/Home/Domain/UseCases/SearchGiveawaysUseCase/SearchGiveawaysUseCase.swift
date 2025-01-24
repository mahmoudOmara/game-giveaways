//
//  SearchGiveawaysUseCase.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import Combine

class SearchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol {
    func execute(
        giveaways: [GiveawayEntity],
        query: String) -> AnyPublisher<[GiveawayEntity], Never> {
        return Just(giveaways)
            .map { giveaways in
                guard !query.isEmpty else { return giveaways }
                
                return giveaways.filter { giveaway in
                    giveaway.title.lowercased().contains(query.lowercased())
                }
            }
            .eraseToAnyPublisher()
    }
}

//
//  GetAllGiveawaysUseCaseProtocol.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import Combine

protocol GetAllGiveawaysUseCaseProtocol {
    func execute() -> AnyPublisher<[GiveawayEntity], Error>
}

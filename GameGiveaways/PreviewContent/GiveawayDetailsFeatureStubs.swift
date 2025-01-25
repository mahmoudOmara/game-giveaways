//
//  GiveawayDetailsFeatureStubs.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

#if DEBUG
import Foundation
import Combine

class GiveawayDetailsFeatureStubs {
    
    class GiveawayDetailsUseCaseStub: GetGiveawayDetailsUseCaseProtocol {
        private let giveawayDetailStub: GiveawayDetailEntity
        
        init(idStub: Int) {
            giveawayDetailStub = GiveawayDetailEntity(
                id: idStub,
                imageURL: URL(string: "https://www.gamerpower.com/offers/1/6717d4efdd754.jpg"),
                title: "Wind Story (Steam) Playtest Key Giveaway",
                isActive: true,
                openGiveawayURL: URL(string: "https://example.com"),
                worth: "$19.99",
                usersCount: 1860,
                type: "Early Access",
                platforms: "PC, Steam",
                endDate: Date(),
                description: """
                Claim your free Wind Story (Steam) Playtest Key and join the playtest! 
                Wind Story is an indie simulation game that immerses players in a rural lifestyle. 
                Check it out!
                """
            )
        }
        
        func execute(giveawayID: Int) -> AnyPublisher<GiveawayDetailEntity, Error> {
            
            if giveawayID ==  giveawayDetailStub.id {
                return Just(giveawayDetailStub)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: NSError(
                    domain: "Test",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Giveaway not found"]))
                    .eraseToAnyPublisher()
            }
        }
    }
}
#endif

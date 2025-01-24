//
//  SearchGiveawaysUseCaseTests.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class SearchGiveawaysUseCaseTests: XCTestCase {
    var useCase: SearchGiveawaysUseCase!
    var giveaways: [GiveawayEntity]!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCase = SearchGiveawaysUseCase()
        giveaways = [
            GiveawayEntity(id: 1, title: "Steam Game", platforms: "PC", description: "Great game!", thumbnailURL: nil),
            GiveawayEntity(id: 2, title: "Epic Giveaway", platforms: "Epic Games", description: "Limited time offer!", thumbnailURL: nil),
        ]
        cancellables = []
    }

    override func tearDown() {
        useCase = nil
        giveaways = nil
        cancellables = nil
        super.tearDown()
    }

    func testFilterGiveaways() {
        let expectation = XCTestExpectation(description: "Filtering giveaways")
        
        useCase.execute(giveaways: giveaways, query: "steam")
            .sink { result in
                XCTAssertEqual(result.count, 1)
                XCTAssertEqual(result.first?.title, "Steam Game")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterEmptyQuery() {
        let expectation = XCTestExpectation(description: "Empty query should return all")
        
        useCase.execute(giveaways: giveaways, query: "")
            .sink { result in
                XCTAssertEqual(result.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}

//
//  GetMoreGiveawaysUseCaseTests.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import XCTest
import Combine
@testable import GameGiveaways

class GetMoreGiveawaysUseCaseTests: XCTestCase {
    
    var mockPlatformRepository: MockPlatformRepository!
    var mockGetGiveawaysByPlatformUseCase: MockGetGiveawaysByPlatformUseCase!
    var mockGetGiveawaysByPlatformsUseCase: MockGetGiveawaysByPlatformsUseCase!
    var getMoreGiveawaysUseCase: GetMoreGiveawaysUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockPlatformRepository = MockPlatformRepository()
        mockGetGiveawaysByPlatformUseCase = MockGetGiveawaysByPlatformUseCase()
        mockGetGiveawaysByPlatformsUseCase = MockGetGiveawaysByPlatformsUseCase()
        
        getMoreGiveawaysUseCase = GetMoreGiveawaysUseCase(
            platformRepository: mockPlatformRepository,
            getGiveawaysByPlatformUseCase: mockGetGiveawaysByPlatformUseCase,
            getGiveawaysByPlatformsUseCase: mockGetGiveawaysByPlatformsUseCase
        )
        
        cancellables = []
    }
    
    override func tearDown() {
        mockPlatformRepository = nil
        mockGetGiveawaysByPlatformUseCase = nil
        mockGetGiveawaysByPlatformsUseCase = nil
        getMoreGiveawaysUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testExecute_Success() {
        let expectation = XCTestExpectation(description: "Successfully fetched more giveaways")
        
        getMoreGiveawaysUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { moreGiveaways in
                XCTAssertFalse(moreGiveaways.epicGames.isEmpty)
                XCTAssertFalse(moreGiveaways.platformGiveaways.isEmpty)
                
                XCTAssertEqual(moreGiveaways.epicGames.count, 1)
                XCTAssertEqual(moreGiveaways.platformGiveaways["Nintendo Switch"]?.count, 2)
                XCTAssertEqual(moreGiveaways.platformGiveaways["PC"]?.count, 1)
                XCTAssertNil(moreGiveaways.platformGiveaways["PS4"])
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testExecute_FailureFetchingEpicGames() {
        let expectation = XCTestExpectation(description: "Fetching epic games giveaways should fail but platform giveaways succeeds")
        mockGetGiveawaysByPlatformUseCase.shouldReturnError = true
        
        getMoreGiveawaysUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected partial success but got failure: \(error.localizedDescription)")
                }
            }, receiveValue: { moreGiveaways in
                XCTAssertTrue(moreGiveaways.epicGames.isEmpty, "Expected epicGames to be empty on failure")
                XCTAssertEqual(moreGiveaways.platformGiveaways["Nintendo Switch"]?.count, 2, "Nintendo Switch giveaways should be returned")
                XCTAssertEqual(moreGiveaways.platformGiveaways["PC"]?.count, 1, "PC giveaways should be returned")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testExecute_FailureFetchingPlatforms() {
        let expectation = XCTestExpectation(description: "Fetching platform giveaways should fail but Epic Games succeeds")
        mockGetGiveawaysByPlatformsUseCase.shouldReturnError = true
        
        getMoreGiveawaysUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected partial success but got failure: \(error.localizedDescription)")
                }
            }, receiveValue: { moreGiveaways in
                XCTAssertFalse(moreGiveaways.epicGames.isEmpty, "Expected epicGames to contain data")
                XCTAssertEqual(moreGiveaways.epicGames.count, 1, "Expected 1 giveaway in epicGames")
                XCTAssertTrue(moreGiveaways.platformGiveaways.isEmpty, "Expected platform giveaways to be empty on failure")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}

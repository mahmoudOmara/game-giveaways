//
//  GetGiveawayDetailsUseCaseTests.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import XCTest
import Combine
@testable import GameGiveaways

class GetGiveawayDetailsUseCaseTests: XCTestCase {
    var mockRepository: MockGiveawaysRepository!
    var useCase: GetGiveawayDetailsUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockGiveawaysRepository()
        useCase = GetGiveawayDetailsUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testExecute_Success() {
        mockRepository.storedGiveaways = [
            GiveawayModel(
                id: 1,
                title: "Test Giveaway",
                worth: "$100",
                thumbnail: "https://example.com/thumb.jpg",
                image: "https://example.com/image.jpg",
                description: "Test giveaway description",
                instructions: "Follow these instructions",
                openGiveawayURL: "https://example.com/open",
                publishedDate: "2024-01-01",
                type: "Game",
                platforms: "PC",
                endDate: "2025-12-31",
                users: 10000,
                status: "Active",
                gamerpowerURL: "https://example.com",
                openGiveaway: "https://example.com/open"
            )
        ]
        
        let expectation = XCTestExpectation(description: "Successfully fetch giveaway details")
        mockRepository.getDetailedGiveawayByID(1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveawayDetail in
                XCTAssertEqual(giveawayDetail.title, "Test Giveaway")
                XCTAssertEqual(giveawayDetail.platforms, "PC")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testExecute_Failure() {
        // Given
        mockRepository.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fail to fetch giveaway details")

        // When
        useCase.execute(giveawayID: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Giveaway not found")
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExecute_Failure_NoData() {
        mockRepository.storedGiveaways = []
        let expectation = XCTestExpectation(description: "Fetch giveaway details should fail")
        
        useCase.execute(giveawayID: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Giveaway not found")
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value in failure case")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExecute_Failure_GiveawayIDNotInStoredList() {
        mockRepository.storedGiveaways = [
            GiveawayModel(
                id: 2,  // Different ID than the requested one
                title: "Another Giveaway",
                worth: "$50",
                thumbnail: "https://example.com/thumb.jpg",
                image: "https://example.com/image.jpg",
                description: "Test giveaway description",
                instructions: "Follow these instructions",
                openGiveawayURL: "https://example.com/open",
                publishedDate: "2024-01-01",
                type: "Game",
                platforms: "PC",
                endDate: "2025-12-31",
                users: 5000,
                status: "Active",
                gamerpowerURL: "https://example.com",
                openGiveaway: "https://example.com/open"
            )
        ]
        
        let expectation = XCTestExpectation(description: "Fail to fetch giveaway details with non-existent ID")
        
        useCase.execute(giveawayID: 1) // ID 1 doesn't exist in the stored list
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Giveaway not found")
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value for a non-existent giveaway ID")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

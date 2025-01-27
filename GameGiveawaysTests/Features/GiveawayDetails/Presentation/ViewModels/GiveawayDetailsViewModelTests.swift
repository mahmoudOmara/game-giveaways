//
//  GiveawayDetailsViewModelTests.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import XCTest
import Combine
@testable import GameGiveaways

class GiveawayDetailsViewModelTests: XCTestCase {
    var mockGiveawayDetailsUseCase: MockGiveawayDetailsUseCase!
    var mockAddFavoriteUseCase: MockAddFavoriteUseCase!
    var mockIsFavoriteUseCase: MockIsFavoriteUseCase!
    var mockRemoveFavoriteUseCase: MockRemoveFavoriteUseCase!
    var mockGiveawayDetailsCoordinator: MockGiveawayDetailsCoordinator!

    var viewModel: GiveawayDetailsViewModel!
    var cancellables: Set<AnyCancellable>!
    
    let giveawayID = 1

    override func setUp() {
        super.setUp()
        mockGiveawayDetailsUseCase = MockGiveawayDetailsUseCase()
        mockAddFavoriteUseCase = MockAddFavoriteUseCase()
        mockIsFavoriteUseCase = MockIsFavoriteUseCase()
        mockRemoveFavoriteUseCase = MockRemoveFavoriteUseCase()
        mockGiveawayDetailsCoordinator = MockGiveawayDetailsCoordinator()

        viewModel = GiveawayDetailsViewModel(
            giveawayID: giveawayID,
            getGiveawayDetailsUseCase: mockGiveawayDetailsUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase,
            isFavoriteUseCase: mockIsFavoriteUseCase,
            coordinator: mockGiveawayDetailsCoordinator)
        cancellables = []
    }

    override func tearDown() {
        mockGiveawayDetailsUseCase = nil
        mockAddFavoriteUseCase = nil
        mockIsFavoriteUseCase = nil
        mockRemoveFavoriteUseCase = nil
        mockGiveawayDetailsCoordinator = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialStateIsIdle() {
        XCTAssertTrue({
            if case .idle = viewModel.state { return true }
            return false
        }(), "Expected initial state to be idle")
    }

    func testFetchGiveawayDetails_Success() {
        let expectedGiveaway = GiveawayDetailEntity(
            id: giveawayID,
            imageURL: URL(string: "https://example.com/image.jpg"),
            title: "Test Giveaway",
            isActive: true,
            openGiveawayURL: URL(string: "https://example.com"),
            worth: "$100",
            usersCount: 5000,
            type: "Game",
            platforms: "PC",
            endDate: Date(),
            description: "Test description"
        )

        mockGiveawayDetailsUseCase.mockGiveawayDetail = expectedGiveaway

        let expectation = XCTestExpectation(description: "Fetch giveaway details successfully")
        viewModel.fetchGiveawayDetails()
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .loading:
                    break
                case .success(let giveaway):
                    XCTAssertEqual(giveaway.id, expectedGiveaway.id)
                    XCTAssertEqual(giveaway.title, expectedGiveaway.title)
                    XCTAssertEqual(giveaway.platforms, expectedGiveaway.platforms)
                    expectation.fulfill()
                case .failure, .idle:
                    XCTFail("Expected success but got \(state)")
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchGiveawayDetails_Failure() {
        mockGiveawayDetailsUseCase.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fail to fetch giveaway details")

        viewModel.fetchGiveawayDetails()
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .failure(let errorMessage):
                    XCTAssertEqual(errorMessage, "Mock error")
                    expectation.fulfill()
                case .success, .loading, .idle:
                    XCTFail("Expected failure but got \(state)")
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchGiveawayDetails_NotFound() {
        let expectation = XCTestExpectation(description: "Fail to fetch giveaway details")

        viewModel.fetchGiveawayDetails()
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .failure(let errorMessage):
                    XCTAssertEqual(errorMessage, "Giveaway not found")
                    expectation.fulfill()
                case .success, .loading, .idle:
                    XCTFail("Expected failure but got \(state)")
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}

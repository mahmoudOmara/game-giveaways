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
    var mockUseCase: MockGiveawayDetailsUseCase!
    var viewModel: GiveawayDetailsViewModel!
    var cancellables: Set<AnyCancellable>!
    
    let giveawayID = 1

    override func setUp() {
        super.setUp()
        mockUseCase = MockGiveawayDetailsUseCase()
        viewModel = GiveawayDetailsViewModel(giveawayID: giveawayID, getGiveawayDetailsUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        mockUseCase = nil
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

        mockUseCase.mockGiveawayDetail = expectedGiveaway

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
        mockUseCase.shouldReturnError = true

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

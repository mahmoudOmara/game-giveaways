//
//  HomeViewModelTests.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class HomeViewModelTests: XCTestCase {
    var mockGetUserProfileUseCase: MockGetUserProfileUseCase!
    var mockGetPlatformsUseCase: MockGetPlatformsUseCase!
    var mockGetAllGiveawaysUseCase: MockGetAllGiveawaysUseCase!
    var mockGetFilteredGiveawaysUseCase: MockGetGiveawaysByPlatformUseCase!
    var viewModel: HomeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockGetUserProfileUseCase = MockGetUserProfileUseCase()
        mockGetPlatformsUseCase = MockGetPlatformsUseCase()
        mockGetAllGiveawaysUseCase = MockGetAllGiveawaysUseCase()
        mockGetFilteredGiveawaysUseCase = MockGetGiveawaysByPlatformUseCase()
        viewModel = HomeViewModel(
            getUserProfileUseCase: mockGetUserProfileUseCase,
            getPlatformsUseCase: mockGetPlatformsUseCase,
            getAllGiveawaysUseCase: mockGetAllGiveawaysUseCase,
            getFilteredGiveawaysUseCase: mockGetFilteredGiveawaysUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        mockGetAllGiveawaysUseCase = nil
        mockGetFilteredGiveawaysUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialStateIsIdle() {
        XCTAssertTrue({
                if case .idle = viewModel.state {
                    return true
                }
                return false
            }(), "Expected state to be idle")
    }

    func testLoadGiveawaysSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched all giveaways")

        viewModel.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .loading:
                    break
                case .success(let giveaways):
                    XCTAssertEqual(giveaways.count, 1)
                    XCTAssertEqual(giveaways.first?.title, "Test Giveaway")
                    expectation.fulfill()
                case .failure, .idle:
                    XCTFail("Expected success state")
                }
            }
            .store(in: &cancellables)

        viewModel.loadGiveaways()
        wait(for: [expectation], timeout: 5.0)
    }

    func testLoadGiveawaysFailure() {
        let expectation = XCTestExpectation(description: "Fetching giveaways should fail")
        mockGetAllGiveawaysUseCase.shouldReturnError = true

        viewModel.$state
            .dropFirst(2)
            .sink { state in
                switch state {
                case .failure(let errorMessage):
                    XCTAssertEqual(errorMessage, "Mock error")
                    expectation.fulfill()
                case .success, .loading, .idle:
                    XCTFail("Expected failure state")
                }
            }
            .store(in: &cancellables)

        viewModel.loadGiveaways()
        wait(for: [expectation], timeout: 5.0)
    }

    func testLoadGiveawaysByPlatformSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched filtered giveaways")

        viewModel.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .loading:
                    break
                case .success(let giveaways):
                    XCTAssertEqual(giveaways.count, 1)
                    XCTAssertEqual(giveaways.first?.platforms, "PC")
                    expectation.fulfill()
                case .failure, .idle:
                    XCTFail("Expected success state")
                }
            }
            .store(in: &cancellables)

        viewModel.loadGiveawaysByPlatform(platform: "PC")
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadGiveawaysByPlatformFailure() {
        let expectation = XCTestExpectation(description: "Fetching platform-specific giveaways should fail")
        mockGetFilteredGiveawaysUseCase.shouldReturnError = true

        viewModel.$state
            .dropFirst(2)
            .sink { state in
                switch state {
                case .failure(let errorMessage):
                    XCTAssertEqual(errorMessage, "Mock error")
                    expectation.fulfill()
                case .success, .loading, .idle:
                    XCTFail("Expected failure state")
                }
            }
            .store(in: &cancellables)

        viewModel.loadGiveawaysByPlatform(platform: "PC")
        wait(for: [expectation], timeout: 5.0)
    }
}

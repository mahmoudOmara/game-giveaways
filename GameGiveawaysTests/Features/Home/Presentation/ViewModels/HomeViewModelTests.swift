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
    var mockSearchGiveawaysUseCase: MockSearchGiveawaysUseCase!
    var mockHomeCoordinator: MockHomeCoordinator!
    
    var viewModel: HomeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockGetUserProfileUseCase = MockGetUserProfileUseCase()
        mockGetPlatformsUseCase = MockGetPlatformsUseCase()
        mockGetAllGiveawaysUseCase = MockGetAllGiveawaysUseCase()
        mockGetFilteredGiveawaysUseCase = MockGetGiveawaysByPlatformUseCase()
        mockSearchGiveawaysUseCase = MockSearchGiveawaysUseCase()
        mockHomeCoordinator = MockHomeCoordinator()
        
        viewModel = HomeViewModel(
            getUserProfileUseCase: mockGetUserProfileUseCase,
            getPlatformsUseCase: mockGetPlatformsUseCase,
            getAllGiveawaysUseCase: mockGetAllGiveawaysUseCase,
            getFilteredGiveawaysUseCase: mockGetFilteredGiveawaysUseCase,
            searchGiveawaysUseCase: mockSearchGiveawaysUseCase,
            coordinator: mockHomeCoordinator
        )
        cancellables = []
    }

    override func tearDown() {
        mockGetUserProfileUseCase = nil
        mockGetPlatformsUseCase = nil
        mockGetAllGiveawaysUseCase = nil
        mockGetFilteredGiveawaysUseCase = nil
        mockSearchGiveawaysUseCase = nil
        mockHomeCoordinator = nil
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

    func testPlatformFilterTriggersLoadGiveaways() {
            let expectation = XCTestExpectation(description: "Platform filter triggers loading of all giveaways")
            
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

            // Trigger fetching giveaways by setting platformFilter
            viewModel.platformFilter = .all
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testPlatformFilterTriggersLoadGiveawaysByPlatform() {
            let expectation = XCTestExpectation(description: "Platform filter triggers filtered giveaways fetch")

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

            // Trigger fetching platform-specific giveaways by setting platformFilter
            viewModel.platformFilter = .specific(PlatformEntity(id: "1", name: "PC"))
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testPlatformFilterTriggersLoadFailure() {
            let expectation = XCTestExpectation(description: "Platform filter change triggers failure")
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

            viewModel.platformFilter = .specific(PlatformEntity(id: "1", name: "PC"))
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testLoadGiveawaysSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched all giveaways")

        viewModel.$state
            .dropFirst(2)
            .sink { state in
                switch state {
                case .success(let giveaways):
                    XCTAssertEqual(giveaways.count, 1)
                    XCTAssertEqual(giveaways.first?.title, "Test Giveaway")
                    expectation.fulfill()
                case .failure, .loading, .idle:
                    XCTFail("Expected success state")
                }
            }
            .store(in: &cancellables)

        viewModel.platformFilter = .all
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

        viewModel.platformFilter = .all
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

        viewModel.platformFilter = .specific(PlatformEntity(id: "1", name: "PC"))
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

        viewModel.platformFilter = .specific(PlatformEntity(id: "1", name: "PC"))
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchGiveaways() {
            let expectation = XCTestExpectation(description: "Search query should return filtered results")

            viewModel.platformFilter = .all  // Load all giveaways first
            
            viewModel.$state
                .dropFirst(2)
                .sink { state in
                    switch state {
                    case .success(let giveaways):
                        XCTAssertEqual(giveaways.count, 1)
                        XCTAssertEqual(giveaways.first?.title, "Test Giveaway")
                        expectation.fulfill()
                    case .failure, .loading, .idle:
                        XCTFail("Expected success state")
                    }
                }
                .store(in: &cancellables)

            viewModel.searchQuery = "Test"
            wait(for: [expectation], timeout: 5.0)
        }

        func testSearchGiveawaysNoResults() {
            let expectation = XCTestExpectation(description: "Search query should return no results")

            viewModel.platformFilter = .all  // Load all giveaways first

            viewModel.$state
                .dropFirst(2)
                .sink { state in
                    switch state {
                    case .success(let giveaways):
                        XCTAssertEqual(giveaways.count, 0)
                        expectation.fulfill()
                    case .failure, .loading, .idle:
                        XCTFail("Expected empty success state")
                    }
                }
                .store(in: &cancellables)

            viewModel.searchQuery = "Nonexistent"
            wait(for: [expectation], timeout: 5.0)
        }
}

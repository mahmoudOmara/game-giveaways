//
//  GiveawaysRemoteDataSourceTests.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class GiveawaysRemoteDataSourceTests: XCTestCase {
    var mockApiClient: MockGameGiveawaysApiClient!
    var dataSource: GiveawaysRemoteDataSource!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockApiClient = MockGameGiveawaysApiClient()
        dataSource = GiveawaysRemoteDataSource(apiClient: mockApiClient)
        cancellables = []
    }
    
    override func tearDown() {
        mockApiClient = nil
        dataSource = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchAllGiveawaysSuccess() {
        let expectation = XCTestExpectation(
            description: "Successfully fetched all giveaways"
        )
        
        dataSource.fetchAllGiveaways()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { giveaways in
                    XCTAssertEqual(giveaways.count, 1)
                    XCTAssertEqual(
                        giveaways.first?.title,
                        "Romopolis (Microsoft Store) Giveaway"
                    )
                    expectation.fulfill()
                })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchAllGiveawaysFailure() {
        mockApiClient.shouldReturnError = true
        let expectation = XCTestExpectation(
            description: "Fetching giveaways should fail"
        )
        
        dataSource.fetchAllGiveaways()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Mock error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchGiveawaysByPlatformSuccess() {
        let expectation = XCTestExpectation(
            description: "Successfully fetched platform-specific giveaways"
        )
        
        dataSource.fetchGiveawaysByPlatform(platform: "Xbox")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveaways in
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.platforms, "Xbox")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchGiveawaysByPlatformFailure() {
        mockApiClient.shouldReturnError = true
        let expectation = XCTestExpectation(
            description: "Fetching platform giveaways should fail"
        )
        
        dataSource.fetchGiveawaysByPlatform(platform: "PC")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Mock error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

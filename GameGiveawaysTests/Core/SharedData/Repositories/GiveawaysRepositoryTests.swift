//
//  GiveawaysRepositoryTests.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class GiveawaysRepositoryTests: XCTestCase {
    var mockDataSource: MockGiveawaysRemoteDataSource!
    var repository: GiveawaysRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockDataSource = MockGiveawaysRemoteDataSource()
        repository = GiveawaysRepository(dataSource: mockDataSource)
        cancellables = []
    }

    override func tearDown() {
        mockDataSource = nil
        repository = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetAllGiveawaysSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched all giveaways from repository")

        repository.getAllGiveaways()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveaways in
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.id, 1)
                XCTAssertEqual(giveaways.first?.title, "Test Giveaway")
                XCTAssertEqual(giveaways.first?.description, "Test description")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetAllGiveawaysFailure() {
        mockDataSource.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetching all giveaways should fail")

        repository.getAllGiveaways()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Mock data source error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetGiveawaysByPlatformSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched giveaways filtered by platform")
        let platforom = "Xbox"
        repository.getGiveawaysByPlatform(platform: platforom)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveaways in
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.id, 2)
                XCTAssertEqual(giveaways.first?.title, "Filtered Giveaway")
                XCTAssertEqual(giveaways.first?.platforms, platforom)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetGiveawaysByPlatformFailure() {
        mockDataSource.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetching platform-specific giveaways should fail")

        repository.getGiveawaysByPlatform(platform: "PC")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Mock data source error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}

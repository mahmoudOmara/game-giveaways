//
//  GetGiveawaysByPlatformUseCaseTests.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class GetGiveawaysByPlatformUseCaseTests: XCTestCase {
    var mockRepository: MockGiveawaysRepository!
    var useCase: GetGiveawaysByPlatformUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockGiveawaysRepository()
        useCase = GetGiveawaysByPlatformUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetGiveawaysByPlatformSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched filtered giveaways by platform")

        useCase.execute(platform: "Xbox")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveaways in
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.title, "Free Xbox Game")
                XCTAssertEqual(giveaways.first?.platforms, "Xbox")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetGiveawaysByPlatformFailure() {
        mockRepository.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetching platform-specific giveaways should fail")

        useCase.execute(platform: "PC")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Mock repository error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}

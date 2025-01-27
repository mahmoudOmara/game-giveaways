//
//  GetAllGiveawaysUseCaseTests.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//


import XCTest
import Combine
@testable import GameGiveaways

class GetAllGiveawaysUseCaseTests: XCTestCase {
    var mockRepository: MockGiveawaysRepository!
    var useCase: GetAllGiveawaysUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockGiveawaysRepository()
        useCase = GetAllGiveawaysUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetAllGiveawaysSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched all giveaways")

        useCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { giveaways in
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.title, "Free Steam Game")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetAllGiveawaysFailure() {
        mockRepository.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetching all giveaways should fail")

        useCase.execute()
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

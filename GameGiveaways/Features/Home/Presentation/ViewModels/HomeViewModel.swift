//
//  HomeViewState.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI
import Combine

enum HomeViewState {
    case idle
    case loading
    case success([GiveawayEntity])
    case failure(String)
}

class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: HomeViewState = .idle

    // MARK: - Dependencies
    private let getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol
    private let getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(
        getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol,
        getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol
    ) {
        self.getAllGiveawaysUseCase = getAllGiveawaysUseCase
        self.getFilteredGiveawaysUseCase = getFilteredGiveawaysUseCase
    }

    // MARK: - Public Methods
    func loadGiveaways() {
        state = .loading
        getAllGiveawaysUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] giveaways in
                self?.state = .success(giveaways)
            })
            .store(in: &cancellables)
    }

    func loadGiveawaysByPlatform(platform: String) {
        state = .loading
        getFilteredGiveawaysUseCase.execute(platform: platform)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] giveaways in
                self?.state = .success(giveaways)
            })
            .store(in: &cancellables)
    }
}

//
//  GiveawayDetailsViewModel.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI
import Combine

enum GiveawayDetailsState {
    case idle
    case loading
    case success(GiveawayDetailEntity)
    case failure(String)
}

class GiveawayDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: GiveawayDetailsState = .idle

    // MARK: - Dependencies
    private let getGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol
    private let giveawayID: Int
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(giveawayID: Int, getGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol) {
        self.giveawayID = giveawayID
        self.getGiveawayDetailsUseCase = getGiveawayDetailsUseCase
    }

    // MARK: - Public Methods
    func fetchGiveawayDetails() {
        state = .loading
        getGiveawayDetailsUseCase.execute(giveawayID: giveawayID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] details in
                self?.state = .success(details)
            })
            .store(in: &cancellables)
    }
}

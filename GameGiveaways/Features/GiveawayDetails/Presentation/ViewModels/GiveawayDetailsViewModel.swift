//
//  GiveawayDetailsViewModel.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI
import Combine

class GiveawayDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: ViewModelState<GiveawayDetailEntity> = .idle
    @Published var isFavorited: Bool
    
    // MARK: - Dependencies
    private let getGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol
    let addFavoriteUseCase: AddFavoriteUseCaseProtocol
    let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    let isFavoriteUseCase: IsFavoriteUseCaseProtocol
    private let giveawayID: Int
    private let coordinator: GiveawayDetailsCoordinatorProtocol

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(giveawayID: Int,
         getGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol,
         addFavoriteUseCase: AddFavoriteUseCaseProtocol,
         removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol,
         isFavoriteUseCase: IsFavoriteUseCaseProtocol,
         coordinator: GiveawayDetailsCoordinatorProtocol) {
        self.giveawayID = giveawayID
        self.getGiveawayDetailsUseCase = getGiveawayDetailsUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.coordinator = coordinator
        
        self.isFavorited = false
        checkIfFavorite()
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
    
    func toggleFavorite() {
        if isFavorited {
            removeFavorite()
        } else {
            addFavorite()
        }
        checkIfFavorite()
    }
    
    func navigateBackToHome() {
        coordinator.back()
    }
    
    // MARK: - Private Methods
    private func checkIfFavorite() {
        isFavorited = isFavoriteUseCase.execute(giveawayID: giveawayID)
    }
    
    private func addFavorite() {
        addFavoriteUseCase.execute(giveawayID: giveawayID)
    }
    
    private func removeFavorite() {
        removeFavoriteUseCase.execute(giveawayID: giveawayID)
    }
}

//
//  MoreViewModel.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI
import Combine

class MoreViewModel: ObservableObject {
    @Published var state: ViewModelState<MorePlatformsGiveawaysEntity> = .idle

    // MARK: - Dependencies
    private let getMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol
    let addFavoriteUseCase: AddFavoriteUseCaseProtocol
    let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    let isFavoriteUseCase: IsFavoriteUseCaseProtocol
    private let coordinator: MorePlatformsCoordinatorProtocol

    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false

    init(
        getMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol,
        coordinator: MorePlatformsCoordinatorProtocol) {
            self.getMoreGiveawaysUseCase = getMoreGiveawaysUseCase
            self.addFavoriteUseCase = addFavoriteUseCase
            self.removeFavoriteUseCase = removeFavoriteUseCase
            self.isFavoriteUseCase = isFavoriteUseCase
            self.coordinator = coordinator
        }
    
    // MARK: - Public Methods
    
    func onAppear() {
        guard !hasLoaded else { return }
        loadGiveaways()
        hasLoaded = true
    }
    
    func loadGiveaways() {
        state = .loading

        getMoreGiveawaysUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                    
                case .finished:
                    break
                }
            } receiveValue: { [weak self] giveaways in
                self?.state = .success(giveaways)
            }
            .store(in: &cancellables)
    }
    
    func navigateToDetail(giveaway: GiveawayEntity) {
        coordinator.navigateToDetail(giveawayID: giveaway.id)
    }
    
    func navigateBackToHome() {
        coordinator.navigateBackToHome()
    }
}

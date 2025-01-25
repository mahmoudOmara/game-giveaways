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

    private let getMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(getMoreGiveawaysUseCase: GetMoreGiveawaysUseCaseProtocol) {
        self.getMoreGiveawaysUseCase = getMoreGiveawaysUseCase
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
}

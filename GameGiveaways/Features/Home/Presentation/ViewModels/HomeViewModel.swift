//
//  HomeViewModel.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: ViewModelState<[GiveawayEntity]> = .idle
    @Published var user: UserEntity?
    @Published var platforms: [PlatformEntity] = []
    @Published var platformFilter: PlatformFilter? {
        didSet {
            refreshConsideringPlatformFilter()
        }
    }
    @Published var searchQuery: String = ""
    @Published private var notSearchedGiveaways: [GiveawayEntity] = []
    
    // MARK: - Dependencies
    private let searchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let getMostPopularPlatformsUseCase: GetMostPopularPlatformsUseCaseProtocol
    private let getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol
    private let getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol
    let addFavoriteUseCase: AddFavoriteUseCaseProtocol
    let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    let isFavoriteUseCase: IsFavoriteUseCaseProtocol
    private let coordinator: HomeCoordinatorProtocol

    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false
    
    // MARK: - Initializer
    init(
        getUserProfileUseCase: GetUserProfileUseCaseProtocol,
        getMostPopularPlatformsUseCase: GetMostPopularPlatformsUseCaseProtocol,
        getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol,
        getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol,
        searchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol,
        coordinator: HomeCoordinatorProtocol
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.getMostPopularPlatformsUseCase = getMostPopularPlatformsUseCase
        self.getAllGiveawaysUseCase = getAllGiveawaysUseCase
        self.getFilteredGiveawaysUseCase = getFilteredGiveawaysUseCase
        self.searchGiveawaysUseCase = searchGiveawaysUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.coordinator = coordinator
        
        setupSearchBinding()
    }
    
    // MARK: - Public Methods
    
    func onAppear() {
        guard !hasLoaded else { return }
        loadUserProfile()
        loadPlatforms()
        platformFilter = .all
        hasLoaded = true
    }
    
    func refreshConsideringPlatformFilter() {
        searchQuery = ""
        if case .specific(let platform) = platformFilter {
            loadGiveawaysByPlatform(platform: platform.name)
        } else {
            loadGiveaways()
        }
    }
    
    func navigateToDetail(giveaway: GiveawayEntity) {
        coordinator.navigateToDetail(giveawayID: giveaway.id)
    }
    
    func navigateToMorePlatforms() {
        coordinator.navigateToMorePlatforms()
    }
    
    private func loadUserProfile() {
        getUserProfileUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    private func loadPlatforms() {
        getMostPopularPlatformsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] platforms in
                self?.platforms = platforms
            }
            .store(in: &cancellables)
    }
    
    private func loadGiveaways() {
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
                self?.notSearchedGiveaways = giveaways
            })
            .store(in: &cancellables)
    }
    
    private func loadGiveawaysByPlatform(platform: String) {
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
                self?.notSearchedGiveaways = giveaways
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Search Setup
    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] query -> AnyPublisher<[GiveawayEntity], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.searchGiveawaysUseCase.execute(
                    giveaways: self.notSearchedGiveaways, query: query)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.state = .success(results)
            }
            .store(in: &cancellables)
    }
}

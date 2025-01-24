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
    private let getPlatformsUseCase: GetPlatformsUseCaseProtocol
    private let getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol
    private let getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(
        getUserProfileUseCase: GetUserProfileUseCaseProtocol,
        getPlatformsUseCase: GetPlatformsUseCaseProtocol,
        getAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol,
        getFilteredGiveawaysUseCase: GetGiveawaysByPlatformUseCaseProtocol,
        searchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.getPlatformsUseCase = getPlatformsUseCase
        self.getAllGiveawaysUseCase = getAllGiveawaysUseCase
        self.getFilteredGiveawaysUseCase = getFilteredGiveawaysUseCase
        self.searchGiveawaysUseCase = searchGiveawaysUseCase
        
        setupSearchBinding()
    }
    
    // MARK: - Public Methods
    func loadUserProfile() {
        getUserProfileUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    func loadPlatforms() {
        getPlatformsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] platforms in
                self?.platforms = platforms
            }
            .store(in: &cancellables)
    }
    
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
                self?.notSearchedGiveaways = giveaways
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
                self?.notSearchedGiveaways = giveaways
            })
            .store(in: &cancellables)
    }
    
    func refreshConsideringPlatformFilter() {
        if case .specific(let platform) = platformFilter {
            loadGiveawaysByPlatform(platform: platform.name)
        } else {
            loadGiveaways()
        }
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

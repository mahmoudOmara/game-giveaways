//
//  HomeView.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                titleSection
                searchBar
                if !viewModel.platforms.isEmpty {
                    platformTabs
                }
                contentView
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadUserProfile()
                viewModel.loadPlatforms()
                viewModel.platformFilter = .all
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            if let user = viewModel.user {
                VStack(alignment: .leading) {
                    Text("👋")
                    Text("Hello, \(user.name)")
                }
                .font(.title2)
                .fontWeight(.medium)

                Spacer()

                AsyncImage(url: user.profileImageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            }
        }
        .padding(.top)
    }

    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Explore")
            Text("Games Giveaways")
        }
        .font(.largeTitle)
        .fontWeight(.heavy)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        TextField("Search Game by name", text: $viewModel.searchQuery)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .font(.system(size: 16))
    }

    // MARK: - Platform Tabs
    private var platformTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                platformButton(title: "all", associatedPlatformFilter: .all)

                ForEach(viewModel.platforms) { platform in
                    platformButton(
                        title: platform.displayName,
                        associatedPlatformFilter: .specific(platform))
                }
                
                morePlatformsButton
            }
        }
    }

    // MARK: - Platform Button Component
    private func platformButton(
        title: String,
        associatedPlatformFilter: PlatformFilter) -> some View {
        let isSelected = viewModel.platformFilter == associatedPlatformFilter
        return Button(
            action: {
                viewModel.platformFilter = associatedPlatformFilter
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            },
            label: {
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .black : .gray)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 6)
            }
        )
    }
    
    private var morePlatformsButton: some View {
        Button(
            action: {
                viewModel.navigateToMorePlatforms()
            },
            label: {
                Text("More")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor)
                    .underline()
                    .padding(.horizontal, 5)
                    .padding(.vertical, 6)
            }
        )
    }

    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        StateDrivenView(
            state: viewModel.state,
            loadingMessage: "Loading giveaways...",
            retryAction: { viewModel.refreshConsideringPlatformFilter() },
            content: { giveaways in
                if giveaways.isEmpty {
                    EmptyStateView(
                        message: "No giveaways available",
                        systemImageName: "tray.fill",
                        actionTitle: "Refresh"
                    ) {
                        viewModel.refreshConsideringPlatformFilter()
                    }
                } else {
                    giveawayListView(giveaways)
                }
            }
        )
    }
    
    private func giveawayListView(_ giveaways: [GiveawayEntity]) -> some View {
        List {
            ForEach(giveaways) { giveaway in
                GiveawayCard(
                    giveaway: giveaway,
                    style: .large,
                    favoriteButtonPlacement: .topTrailing,
                    showPlatforms: true,
                    showDiscription: true)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .onTapGesture {
                        viewModel.navigateToDetail(giveaway: giveaway)
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.refreshConsideringPlatformFilter()
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            getUserProfileUseCase: HomeFeatureStubs.GetUserProfileUseCaseStub(),
            getMostPopularPlatformsUseCase: HomeFeatureStubs.GetMostPopularPlatformsUseCaseStub(),
            getAllGiveawaysUseCase: HomeFeatureStubs.GetAllGiveawaysUseCaseStub(),
            getFilteredGiveawaysUseCase: HomeFeatureStubs.GetGiveawaysByPlatformUseCaseStub(),
            searchGiveawaysUseCase: HomeFeatureStubs.StubSearchGiveawaysUseCase(),
            addFavoriteUseCase: FavoriteUseCaseStubs.AddFavoriteUseCaseStub(),
            removeFavoriteUseCase: FavoriteUseCaseStubs.RemoveFavoriteUseCaseStub(),
            isFavoriteUseCase: FavoriteUseCaseStubs.IsFavoriteUseCaseStub(),
            coordinator: HomeFeatureStubs.StubHomeCoordinator()
        )
    )
}

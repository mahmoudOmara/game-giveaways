//
//  MoreView.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var viewModel: MoreViewModel
    
    init(viewModel: MoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        StateDrivenView(
            state: viewModel.state,
            loadingMessage: "Loading More Categories...",
            retryAction: { viewModel.loadGiveaways() },
            content: {
                contentView(featuredGiveaways: $0.epicGames, categories: $0.platformGiveaways)
            }
        )
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadGiveaways()
        }
    }
    
    // MARK: - Success State Content View
    private func contentView(featuredGiveaways: [GiveawayEntity], categories: [String: [GiveawayEntity]]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Categories")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                featuredCarousel(giveaways: featuredGiveaways)
                
                categoriesList(categories: categories)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Featured Carousel View
    private func featuredCarousel(giveaways: [GiveawayEntity]) -> some View {
        TabView {
            ForEach(giveaways) { giveaway in
                carouselCard(giveaway: giveaway)
            }
        }
        .frame(height: 250)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    // MARK: - Carousel Card
    private func carouselCard(giveaway: GiveawayEntity) -> some View {
        GiveawayCard(
            giveaway: giveaway,
            style: .large,
            favoriteButtonPlacement: .none,
            showPlatforms: false,
            showDiscription: true)
    }
    
    // MARK: - Remaining Categories View
    private func categoriesList(categories: [String: [GiveawayEntity]]) -> some View {
        ForEach(categories.sorted(by: { $0.key < $1.key }), id: \.key) { categoryName, giveaways in
            if !giveaways.isEmpty {
                Section(
                    header: Text(categoryName).font(.headline).bold()) {
                    giveawaysCategoryCards(giveaways: giveaways)
                }
            }
        }
    }
    
    // MARK: - Giveaways Category Cards
    private func giveawaysCategoryCards(giveaways: [GiveawayEntity]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(giveaways) { giveaway in
                    GiveawayCard(
                        giveaway: giveaway,
                        style: .small,
                        favoriteButtonPlacement: .bottomTrailing,
                        showPlatforms: false,
                        showDiscription: false)
                }
            }
        }
    }
}

#Preview {
    MoreView(
        viewModel: MoreViewModel(
            getMoreGiveawaysUseCase: MoreFeatureStubs.StubGetMoreGiveawaysUseCase()
        )
    )
}

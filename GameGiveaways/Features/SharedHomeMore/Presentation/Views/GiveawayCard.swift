//
//  GiveawayCard.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI
struct GiveawayCard: View {
    
    enum GiveawayCardStyle {
        case large
        case medium
        case small
    }

    enum FavoriteButtonPlacement {
        case topTrailing
        case bottomTrailing
        case none
    }
    
    // MARK: - Dependencies
    @StateObject private var viewModel: GiveawayCardViewModel
    let style: GiveawayCardStyle
    let favoriteButtonPlacement: FavoriteButtonPlacement
    let showPlatforms: Bool
    let showDescription: Bool
    
    init(
        viewModel: GiveawayCardViewModel,
        style: GiveawayCardStyle,
        favoriteButtonPlacement: FavoriteButtonPlacement,
        showPlatforms: Bool,
        showDescription: Bool
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.style = style
        self.favoriteButtonPlacement = favoriteButtonPlacement
        self.showPlatforms = showPlatforms
        self.showDescription = showDescription
    }

    var body: some View {
        ZStack(alignment: favoriteButtonAlignment) {
            thumbnailLayer
            gradientLayer
            textContent
            
            if favoriteButtonPlacement != .none {
                favoriteButton
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    // MARK: - Thumbnail Layer
    private var thumbnailLayer: some View {
        AsyncImage(url: viewModel.giveaway.thumbnailURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            default:
                ProgressView()
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - Gradient Overlay
    private var gradientLayer: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    // MARK: - Text Content
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.giveaway.title)
                .font(textSize)
                .bold()
                .foregroundColor(.white)
            if showPlatforms {
                Text(viewModel.giveaway.platforms)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            if showDescription {
                Text(viewModel.giveaway.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Favorite Button
    private var favoriteButton: some View {
        
        Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
            .foregroundColor(.white)
            .padding(8)
            .background(Color.black.opacity(0.5))
            .clipShape(Circle())
            .padding()
            .highPriorityGesture(
                TapGesture().onEnded({
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.toggleFavorite()
                })
            )
    }

    // MARK: - Computed Properties
    private var favoriteButtonAlignment: Alignment {
        switch favoriteButtonPlacement {
        case .topTrailing: return .topTrailing
        case .bottomTrailing: return .bottomTrailing
        case .none: return .topTrailing // Default to topTrailing if none is provided, but button won't appear
        }
    }

    private var cardSize: CGSize {
        switch style {
        case .large: return CGSize(width: UIScreen.main.bounds.width - 100, height: 220)
        case .medium: return CGSize(width: 300, height: 160)
        case .small: return CGSize(width: 150, height: 150)
        }
    }

    private var textSize: Font {
        switch style {
        case .large: return .title
        case .medium: return .headline
        case .small: return .caption2
        }
    }
}

#Preview {
    GiveawayCard(
        viewModel: GiveawayCardViewModel(
            // swiftlint:disable:next force_unwrapping
            giveaway: HomeFeatureStubs.sampleGiveaways.first!,
            addFavoriteUseCase: FavoriteUseCaseStubs.AddFavoriteUseCaseStub(),
            removeFavoriteUseCase: FavoriteUseCaseStubs.RemoveFavoriteUseCaseStub(),
            isFavoriteUseCase: FavoriteUseCaseStubs.IsFavoriteUseCaseStub()),
        style: .large,
        favoriteButtonPlacement: .topTrailing,
        showPlatforms: true,
        showDescription: true)
}

#Preview {
    GiveawayCard(
        viewModel: GiveawayCardViewModel(
            // swiftlint:disable:next force_unwrapping
            giveaway: HomeFeatureStubs.sampleGiveaways.first!,
            addFavoriteUseCase: FavoriteUseCaseStubs.AddFavoriteUseCaseStub(),
            removeFavoriteUseCase: FavoriteUseCaseStubs.RemoveFavoriteUseCaseStub(),
            isFavoriteUseCase: FavoriteUseCaseStubs.IsFavoriteUseCaseStub()),
        style: .medium,
        favoriteButtonPlacement: .none,
        showPlatforms: false,
        showDescription: true)
}

#Preview {
    GiveawayCard(
        viewModel: GiveawayCardViewModel(
            // swiftlint:disable:next force_unwrapping
            giveaway: HomeFeatureStubs.sampleGiveaways.first!,
            addFavoriteUseCase: FavoriteUseCaseStubs.AddFavoriteUseCaseStub(),
            removeFavoriteUseCase: FavoriteUseCaseStubs.RemoveFavoriteUseCaseStub(),
            isFavoriteUseCase: FavoriteUseCaseStubs.IsFavoriteUseCaseStub()),
        style: .small,
        favoriteButtonPlacement: .bottomTrailing,
        showPlatforms: false,
        showDescription: false)
}

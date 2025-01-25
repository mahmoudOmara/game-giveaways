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
    
    let giveaway: GiveawayEntity
    let style: GiveawayCardStyle
    let favoriteButtonPlacement: FavoriteButtonPlacement
    let showPlatforms: Bool
    let showDiscription: Bool

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
        AsyncImage(url: giveaway.thumbnailURL) { phase in
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
            Text(giveaway.title)
                .font(textSize)
                .bold()
                .foregroundColor(.white)
            if showPlatforms {
                Text(giveaway.platforms)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            if showDiscription {
                Text(giveaway.description)
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
        Button(
            action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            },
            label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            })
        .padding()
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
        case .large: return CGSize(width: UIScreen.main.bounds.width - 40, height: 220)
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
        // swiftlint:disable:next force_unwrapping
        giveaway: HomeFeatureStubs.sampleGiveaways.first!,
        style: .large,
        favoriteButtonPlacement: .topTrailing,
        showPlatforms: true,
        showDiscription: true)
}

#Preview {
    GiveawayCard(
        // swiftlint:disable:next force_unwrapping
        giveaway: HomeFeatureStubs.sampleGiveaways.first!,
        style: .medium,
        favoriteButtonPlacement: .none,
        showPlatforms: false,
        showDiscription: true)
        .frame(maxWidth: .infinity, minHeight: 200)
}

#Preview {
    GiveawayCard(
        // swiftlint:disable:next force_unwrapping
        giveaway: HomeFeatureStubs.sampleGiveaways.first!,
        style: .small,
        favoriteButtonPlacement: .bottomTrailing,
        showPlatforms: false,
        showDiscription: false)
        .frame(maxWidth: .infinity, minHeight: 200)
}

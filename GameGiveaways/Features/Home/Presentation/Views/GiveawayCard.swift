//
//  GiveawayCard.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI

struct GiveawayCard: View {
    let giveaway: GiveawayEntity
    @State private var isFavorited = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            thumbnailLayer
            Color.red
            gradientLayer
            contentLayer
            favoriteButton
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .clipped()
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var thumbnailLayer: some View {
        AsyncImage(url: giveaway.thumbnailURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray.opacity(0.6))
                    .clipped()

            default:
                ProgressView()
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }

    private var gradientLayer: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var contentLayer: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(giveaway.title)
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .accessibilityLabel("Giveaway title: \(giveaway.title)")

            Text(giveaway.platforms)
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()

            Text(giveaway.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.black.opacity(0.3)) // Background to ensure readability
    }

    private var favoriteButton: some View {
        Button(
            action: {
                isFavorited.toggle()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            },
            label: {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .foregroundColor(isFavorited ? .red : .white)
                    .padding(10)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            })
        .padding(12)
    }
}

#Preview {
    // swiftlint:disable:next force_unwrapping
    GiveawayCard(giveaway: HomeFeatureStubs.sampleGiveaways.first!)
        .frame(maxWidth: .infinity, minHeight: 200)
}

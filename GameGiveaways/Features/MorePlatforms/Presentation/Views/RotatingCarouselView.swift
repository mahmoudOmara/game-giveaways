//
//  RotatingCarouselView.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUI

struct RotatingCarouselView: View {
    @ObservedObject private var viewModel: MoreViewModel

    let giveaways: [GiveawayEntity]
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    private let cardWidth: CGFloat = 300
    private let spacing: CGFloat = 40
    
    init(viewModel: MoreViewModel, giveaways: [GiveawayEntity]) {
        self.viewModel = viewModel
        self.giveaways = giveaways
    }
    
    var body: some View {
        VStack(spacing: 10) {
            carouselStack
            indexIndicator
        }
    }
    
    // MARK: - Carousel Stack
    private var carouselStack: some View {
        ZStack {
            ForEach(Array(giveaways.enumerated()), id: \.element.id) { index, giveaway in
                carouselCard(giveaway: giveaway, index: index)
                    .offset(x: cardOffset(for: index))
                    .scaleEffect(getScaleAmount(for: index))
                    .rotation3DEffect(
                        .degrees(rotationAngleX(for: index)),
                        axis: (x: 1.0, y: 0.0, z: 0.0),
                        perspective: 0.1
                    )
                    .rotation3DEffect(
                        .degrees(rotationAngleZ(for: index)),
                        axis: (x: 0.0, y: 0.0, z: 1.0)
                    )
                    .opacity(getOpacity(for: index))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    handleSwipeEnd(translation: value.translation.width)
                                    dragOffset = 0
                                }
                            }
                    )
                    .animation(.easeInOut, value: dragOffset)
                    .onTapGesture {
                        viewModel.navigateToDetail(giveaway: giveaway)
                    }
            }
        }
    }
    
    // MARK: - Index Indicator
    private var indexIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<giveaways.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index == currentIndex ? Color.red : Color.gray.opacity(0.5))
                    .frame(width: index == currentIndex ? 20 : 8, height: 8)
                    .transition(.scale)
                    .animation(.spring(), value: currentIndex)
            }
        }
    }
    
    // MARK: - Card View
    private func carouselCard(giveaway: GiveawayEntity, index: Int) -> some View {
        GiveawayCard(
            viewModel: GiveawayCardViewModel(
                giveaway: giveaway,
                addFavoriteUseCase: viewModel.addFavoriteUseCase,
                removeFavoriteUseCase: viewModel.removeFavoriteUseCase,
                isFavoriteUseCase: viewModel.isFavoriteUseCase
            ),
            style: .medium,
            favoriteButtonPlacement: .none,
            showPlatforms: false,
            showDescription: true
        )
    }
    
    // MARK: - Offset Calculation
    private func cardOffset(for index: Int) -> CGFloat {
        let baseOffset = CGFloat(index - currentIndex) * (cardWidth + spacing)
        return baseOffset + dragOffset
    }
    
    // MARK: - Scaling Effect
    private func getScaleAmount(for index: Int) -> CGFloat {
        let scaleFactor: CGFloat = 0.85
        let maxScaleDiff: CGFloat = 0.3  // Maximum difference in scale
        let distance = abs(cardOffset(for: index))  // Distance from the center card
        let normalizedDistance = min(distance / (cardWidth + spacing), 1.0)  // Normalize distance
        
        let scaleAdjustment = maxScaleDiff * (1.0 - normalizedDistance)  // Adjust scale based on distance
        return index == currentIndex ? 1.0 : scaleFactor + scaleAdjustment
    }
    
    // MARK: - Rotation Effect (3D Based on Offset)
    private func rotationAngleX(for index: Int) -> Double {
        let offset = cardOffset(for: index)
        let maxRotation: Double = 60
        let normalizedOffset = min(abs(offset / cardWidth), 1.0)
        return maxRotation * normalizedOffset
    }
    
    private func rotationAngleZ(for index: Int) -> Double {
        let offset = cardOffset(for: index)
        let maxRotation: Double = 10
        let normalizedOffset = min((offset / cardWidth), 1.0)
        return maxRotation * normalizedOffset
    }
    
    // MARK: - Handle Swipe End
    private func handleSwipeEnd(translation: CGFloat) {
        let threshold: CGFloat = cardWidth / 3
        if translation > threshold, currentIndex > 0 {
            currentIndex -= 1
        } else if translation < -threshold, currentIndex < giveaways.count - 1 {
            currentIndex += 1
        }
    }
    
    // MARK: - Opacity Effect Based on Offset
    private func getOpacity(for index: Int) -> Double {
        let offset = abs(cardOffset(for: index))
        let maxDistance = cardWidth + spacing
        let normalizedOffset = min(offset / maxDistance, 1.0)
        // Reduce opacity for further cards (1.0 -> 0.4)
        let minOpacity: Double = 0.4
        return 1.0 - (normalizedOffset * (1.0 - minOpacity))
    }
}

#Preview {
    RotatingCarouselView(
        viewModel: MoreViewModel(
            getMoreGiveawaysUseCase: MoreFeatureStubs.StubGetMoreGiveawaysUseCase(),
            addFavoriteUseCase: FavoriteUseCaseStubs.AddFavoriteUseCaseStub(),
            removeFavoriteUseCase: FavoriteUseCaseStubs.RemoveFavoriteUseCaseStub(),
            isFavoriteUseCase: FavoriteUseCaseStubs.IsFavoriteUseCaseStub(),
            coordinator: MoreFeatureStubs.StubMorePlatformsCoordinator()
        ),
        giveaways: MoreFeatureStubs.epicGamesGiveaways)
}

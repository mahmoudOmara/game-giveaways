//
//  GiveawayDetailsView.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct GiveawayDetailsView: View {
    @StateObject private var viewModel: GiveawayDetailsViewModel

    init(viewModel: GiveawayDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        StateDrivenView(
            state: viewModel.state,
            loadingMessage: "Loading details...",
            retryAction: { viewModel.fetchGiveawayDetails() },
            content: { giveawayDetails in
                giveawayContent(giveawayDetails)
            }
        )
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchGiveawayDetails()
        }
    }

    // MARK: - Success View
    private func giveawayContent(_ details: GiveawayDetailEntity) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerView(details)
                statsSection(details)
                detailsSection(details)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Header Section
    // swiftlint:disable:next function_body_length
    private func headerView(_ details: GiveawayDetailEntity) -> some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: details.imageURL) { phase in
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
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            HStack {
                Button(
                    action: { /* Handle back navigation */ },
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.6)))
                    })
                Spacer()
                Button(
                    action: { /* Handle favorite action */ },
                    label: {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.6)))
                    })
            }
            .padding(.horizontal)
            .padding(.top, 40)
            
            VStack {
                Spacer()
                HStack {
                    HStack(alignment: .bottom) {
                        Text(details.title)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Button(
                        action: {},
                        label: {
                            Text("Get it")
                                .foregroundColor(.primary)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        })
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 300)
    }

    // MARK: - Stats Section
    private func statsSection(_ details: GiveawayDetailEntity) -> some View {
        HStack {
            statItem(icon: "dollarsign.square.fill", value: details.worth)
            statItem(icon: "person.2.fill", value: "\(details.usersCount)")
            statItem(icon: "gamecontroller.fill", value: details.type)
        }
        .frame(maxWidth: .infinity)
    }

    private func statItem(icon: String, value: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
            Text(value)
                .font(.headline)
                .bold()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Details Section
    private func detailsSection(_ details: GiveawayDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Platforms")
                .font(.headline)
                .bold()
            Text(details.platforms)
                .font(.body)
                .foregroundColor(.gray)

            if let endDate = details.endDate {
                Text("Giveaway End Date")
                    .font(.headline)
                    .bold()
                Text(endDate.formatted())
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Text("Description")
                .font(.headline)
                .bold()
            Text(details.description)
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    let id = 1
    GiveawayDetailsView(
        viewModel: GiveawayDetailsViewModel(
            giveawayID: id,
            getGiveawayDetailsUseCase: GiveawayDetailsFeatureStubs.GiveawayDetailsUseCaseStub(idStub: id)
        )
    )
}

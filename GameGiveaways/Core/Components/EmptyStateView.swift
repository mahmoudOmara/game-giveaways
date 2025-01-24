//
//  EmptyStateView.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    let systemImageName: String
    let actionTitle: String?
    var tintColor: Color = .accentColor
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(tintColor)

            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(tintColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 50)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }
}

#Preview {
    EmptyStateView(
        message: "No data found",
        systemImageName: "folder.fill",
        actionTitle: "Try Again",
        tintColor: .red,
        action: {
            print("Retry action triggered")
        }
    )
}

#Preview {
    EmptyStateView(
        message: "No items available",
        systemImageName: "tray.fill",
        actionTitle: nil,
        action: nil
    )
}

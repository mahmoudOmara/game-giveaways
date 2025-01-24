//
//  LoadingView.swift
//  GameGiveaways
//
//  Created by mac on 24/01/2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String?
    var tintColor: Color = .accentColor
    var scale: CGFloat = 1.5

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                .scaleEffect(scale)
            
            if let message = message {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView(message: "Fetching data, please wait...", tintColor: .red)
}

#Preview {
    LoadingView(message: "Preparing content...", tintColor: .green, scale: 3.0)
}

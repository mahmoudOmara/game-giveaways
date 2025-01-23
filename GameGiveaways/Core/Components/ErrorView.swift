//
//  ErrorView.swift
//  GameGiveaways
//
//  Created by mac on 23/01/2025.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Oops! Something went wrong")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Retry")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }
}

#Preview {
    ErrorView(message: "Network connection lost") {
        print("Retry tapped")
    }
}

#Preview {
    ErrorView(message: "An unknown error occurred", retryAction: nil)
}

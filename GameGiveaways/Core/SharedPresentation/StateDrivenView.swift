//
//  StateDrivenView.swift
//  GameGiveaways
//
//  Created by mac on 25/01/2025.
//

import SwiftUI

struct StateDrivenView<Content: View, DataType>: View {
    let state: ViewModelState<DataType>
    let loadingMessage: String
    let retryAction: (() -> Void)?
    let content: (DataType) -> Content

    var body: some View {
        switch state {
        case .idle, .loading:
            LoadingView(message: loadingMessage)
        
        case .success(let data):
            content(data)

        case .failure(let error):
            ErrorView(message: error, retryAction: retryAction)
        }
    }
}

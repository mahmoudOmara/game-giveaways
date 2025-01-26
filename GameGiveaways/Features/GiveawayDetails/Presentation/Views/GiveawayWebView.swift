//
//  GiveawayWebView.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import SwiftUI
import WebKit

struct GiveawayWebView: View {
    let url: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebViewContainer(url: url)
                .navigationBarItems(leading: closeButton)
        }
    }
    
    private var closeButton: some View {
        Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            },
            label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            })
    }
}

private struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates required for now
    }
}

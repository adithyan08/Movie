//
//  ErrorView.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//
import SwiftUI
struct ErrorView: View {
    let errorMessage: String
    let retryAction: () async -> Void

    @State private var bounce = false

    var body: some View {
        ZStack {
            Color.clear
            VStack(spacing: 16) {
                Spacer() // Push content down a bit to avoid top clipping
                
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .offset(y: bounce ? -6 : 6)
                    .animation(
                        Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                        value: bounce
                    )
                    .onAppear {
                        bounce = true
                    }

                Text("Error Loading Details")
                    .font(.headline)

                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button("Try Again") {
                    Task {
                        await retryAction()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer() // Push content up to center vertically
            }
            .frame(maxWidth: 300)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 8)
            .padding(.horizontal, 40)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

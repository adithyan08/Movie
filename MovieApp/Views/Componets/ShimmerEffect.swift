//
//  ShimmerEffect.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Color.white
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .white.opacity(0.6), .clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .rotationEffect(.degrees(30))
                                .offset(x: phase * geometry.size.width * 3, y: 0)
                        )
                        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: phase)
                }
            )
            .onAppear {
                phase = 1
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}

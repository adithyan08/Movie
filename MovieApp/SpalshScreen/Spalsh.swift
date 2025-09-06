//
//  Spalsh.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
       @State private var logoOpacity = 0.0
    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(LocalStorageService.shared) // Your main view
                } else {
                    VStack {
                        Spacer()
                        Image("Logo") // Your logo
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 100)
                            .foregroundColor(.green)
                            .scaleEffect(logoScale)
                                                .opacity(logoOpacity)
                                                .onAppear {
                                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                                                        self.logoScale = 1.0
                                                        self.logoOpacity = 3.0
                                                    }
                                                }

                        Spacer()
                        if #available(iOS 15.0, *) {
                            Text("Version 1.0")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .padding(.top, 10)
                                .padding(.bottom, 20) // add this to lift text above safe area
                                .foregroundStyle(.white)
                        } else {
                            Text("Version 1.0")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .padding(.top, 10)
                                .padding(.bottom, 20) // lift for earlier iOS versions too
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .onAppear {
                        // Delay before transitioning to main view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
                }
            }
    }


#Preview {
    SplashScreen()
}

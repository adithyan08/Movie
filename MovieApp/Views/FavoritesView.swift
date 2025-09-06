//
//  FavoritesView.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoriteMovies.isEmpty && !viewModel.isLoading {
                    EmptyStateView(message: "No favorite movies yet")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favoriteMovies) { movie in
                                MovieCardView(movie: movie)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                Task {
                    await viewModel.loadFavoriteMovies()
                }
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading favorites...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                }
            )
        }
    }
}

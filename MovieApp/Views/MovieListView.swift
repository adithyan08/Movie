//
//  MovieListView.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI
struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var showingErrorAlert = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                VStack(spacing: 15) {
                    SearchBarView(text: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if viewModel.movies.isEmpty && !viewModel.isLoading {
                        EmptyStateView(
                            message: viewModel.searchText.isEmpty ?
                            "No movies available" :
                                "No movies found for '\(viewModel.searchText)'"
                        )
                    } else {
                        // Use custom RefreshableScrollView for iOS 14+ compatibility
                        RefreshableScrollView {
                            await viewModel.refresh()
                        } content: {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.movies) { movie in
                                    MovieCardView(movie: movie)
                                        .onAppear {
                                            Task {
                                                await viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
                                            }
                                        }
                                }
                                
                                if viewModel.isLoading {
                                    LoadingRowView()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                }
                .navigationTitle("Movies")
                .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                    Button("OK") {
                        viewModel.errorMessage = nil
                    }
                    Button("Retry") {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
            } else {
                // Fallback on earlier versions
                

            }
        }
    }
}

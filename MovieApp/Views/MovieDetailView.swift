//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    @EnvironmentObject private var localStorage: LocalStorageService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ScrollView {
                if let movieDetail = viewModel.movieDetail {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header Image
                        CompatibleAsyncImage(url: movieDetail.backdropURL ?? movieDetail.posterURL) { image in
                            image
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .shimmer()
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.largeTitle)
                                )
                        }
                        .clipped()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Title and Rating
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(movieDetail.title)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    if let tagline = movieDetail.tagline, !tagline.isEmpty {
                                        Text(tagline)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .italic()
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    localStorage.toggleFavorite(movie.id)
                                }) {
                                    Image(systemName: localStorage.isFavorite(movie.id) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                        .font(.title)
                                }
                            }
                            
                            // Movie Info
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Rating")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text(String(format: "%.1f", movieDetail.voteAverage))
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Runtime")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(movieDetail.formattedRuntime)
                                        .fontWeight(.semibold)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Release")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(movieDetail.releaseDate)
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                            }
                            
                            // Genres
                            if !movieDetail.genres.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Genres")
                                        .font(.headline)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(movieDetail.genres) { genre in
                                                Text(genre.name)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color(.systemGray5))
                                                    .cornerRadius(16)
                                                    .font(.caption)
                                            }
                                        }
                                        .padding(.horizontal, 1)
                                    }
                                }
                            }
                            
                            // Overview
                            if !movieDetail.overview.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Overview")
                                        .font(.headline)
                                    
                                    Text(movieDetail.overview)
                                        .font(.body)
                                        .lineSpacing(4)
                                }
                            }
                            
                            // Production Companies
                            if !movieDetail.productionCompanies.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Production")
                                        .font(.headline)
                                    
                                    Text(movieDetail.productionCompanies.map { $0.name }.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    
                }
            }
             
                
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
            }
            
            .onAppear {
                Task {
                    await viewModel.fetchMovieDetails(id: movie.id)
                }
            }
            if viewModel.isLoading {
               
               VStack {
                   Spacer()
                   Image(systemName: "popcorn.fill")
                       .resizable()
                       .frame(width: 50, height: 50)
                       .shimmer()
                   Text("Popcorn ready? Loading your movie picks..")
                       .font(.headline)
                       .foregroundColor(.secondary)
                   Spacer()
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               
               
               
           } else if let errorMessage = viewModel.errorMessage {
               
               ErrorView(errorMessage: errorMessage) {
                   await viewModel.fetchMovieDetails(id: movie.id)
               }
           }
        }
    }
}

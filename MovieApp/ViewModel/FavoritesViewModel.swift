//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
   
    @Published var favoriteMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let tmdbService: TMDbService
    private let localStorageService: LocalStorageService
    private var cancellables = Set<AnyCancellable>()
    
    init(tmdbService: TMDbService = TMDbService(),
         localStorageService: LocalStorageService = LocalStorageService.shared) {
        self.tmdbService = tmdbService
        self.localStorageService = localStorageService
        
        // Listen for changes to favorite movie IDs
        localStorageService.$favoriteMovieIds
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.loadFavoriteMovies()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadFavoriteMovies() async {
        let favoriteIds = Array(localStorageService.favoriteMovieIds)
        
        guard !favoriteIds.isEmpty else {
            favoriteMovies = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var movies: [Movie] = []
        
        for id in favoriteIds {
            do {
                let movieDetail = try await tmdbService.fetchMovieDetails(id: id)
                
                // Convert MovieDetail to Movie for display
                let movie = Movie(
                    id: movieDetail.id,
                    title: movieDetail.title,
                    overview: movieDetail.overview,
                    posterPath: movieDetail.posterPath,
                    backdropPath: movieDetail.backdropPath,
                    releaseDate: movieDetail.releaseDate,
                    voteAverage: movieDetail.voteAverage,
                    voteCount: movieDetail.voteCount,
                    popularity: movieDetail.popularity,
                    adult: movieDetail.adult,
                    originalLanguage: movieDetail.originalLanguage,
                    originalTitle: movieDetail.originalTitle,
                    genreIds: movieDetail.genres.map { $0.id }
                )
                
                movies.append(movie)
                
            } catch {
                print("Error fetching favorite movie \(id): \(error)")
            }
        }
        
        favoriteMovies = movies.sorted { $0.title < $1.title }
        isLoading = false
    }
    
    func removeFavorite(_ movieId: Int) {
        localStorageService.removeFromFavorites(movieId)
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        return localStorageService.isFavorite(movieId)
    }
}

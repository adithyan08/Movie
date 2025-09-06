//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let tmdbService: TMDbService
    private let localStorageService: LocalStorageService
    
    init(tmdbService: TMDbService = TMDbService(),
         localStorageService: LocalStorageService = LocalStorageService.shared) {
        self.tmdbService = tmdbService
        self.localStorageService = localStorageService
    }
    
    func fetchMovieDetails(id: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let details = try await tmdbService.fetchMovieDetails(id: id)
            movieDetail = details
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching movie details: \(error)")
        }
        
        isLoading = false
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        return localStorageService.isFavorite(movieId)
    }
    
    func toggleFavorite(_ movieId: Int) {
        localStorageService.toggleFavorite(movieId)
    }
}

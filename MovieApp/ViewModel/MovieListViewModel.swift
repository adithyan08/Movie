// ViewModels.swift
import Foundation
import SwiftUI
import Combine

// MARK: - Movie List View Model
@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var isSearching = false
    
    private let tmdbService: TMDbService
    private let localStorageService: LocalStorageService
    private var currentPage = 1
    private var totalPages = 1
    private var cancellables = Set<AnyCancellable>()
    
    
    init(tmdbService: TMDbService = TMDbService(), 
         localStorageService: LocalStorageService = LocalStorageService.shared) {
        self.tmdbService = tmdbService
        self.localStorageService = localStorageService
        
        // Setup search debouncing
        setupSearchDebouncing()
        
        // Load popular movies on init
        Task {
            await fetchPopularMovies()
        }
    }
    
    private func setupSearchDebouncing() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task { @MainActor in
                    if searchText.isEmpty {
                        await self?.fetchPopularMovies()
                    } else {
                        await self?.searchMovies()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func fetchPopularMovies(refresh: Bool = false) async {
        if refresh {
            currentPage = 1
            movies.removeAll()
        }
        
        guard !isLoading else { return }
        
        isLoading = true
        isSearching = false
        errorMessage = nil
        
        do {
            let response = try await tmdbService.fetchPopularMovies(page: currentPage)
            
            if refresh {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            
            totalPages = response.totalPages
            currentPage = response.page
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching popular movies: \(error)")
        }
        
        isLoading = false
    }
    
    func searchMovies() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await fetchPopularMovies(refresh: true)
            return
        }
        
        guard !isLoading else { return }
        
        isLoading = true
        isSearching = true
        errorMessage = nil
        movies.removeAll()
        currentPage = 1
        
        do {
            let response = try await tmdbService.searchMovies(query: searchText, page: currentPage)
            movies = response.results
            totalPages = response.totalPages
        } catch {
            errorMessage = error.localizedDescription
            print("Error searching movies: \(error)")
        }
        
        isLoading = false
    }
    
    func loadMoreMoviesIfNeeded(currentMovie: Movie) async {
        guard let currentIndex = movies.firstIndex(where: { $0.id == currentMovie.id }) else {
            return
        }
        
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        
        if currentIndex >= thresholdIndex && currentPage < totalPages && !isLoading {
            currentPage += 1
            
            if isSearching {
                await loadMoreSearchResults()
            } else {
                await fetchPopularMovies()
            }
        }
    }
    
    private func loadMoreSearchResults() async {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        
        do {
            let response = try await tmdbService.searchMovies(query: searchText, page: currentPage)
            movies.append(contentsOf: response.results)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func refresh() async {
        if isSearching {
            await searchMovies()
        } else {
            await fetchPopularMovies(refresh: true)
        }
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        return localStorageService.isFavorite(movieId)
    }
    
    func toggleFavorite(_ movieId: Int) {
        localStorageService.toggleFavorite(movieId)
    }
}


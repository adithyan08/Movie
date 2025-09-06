//
//  LocalStorage.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
class LocalStorageService: ObservableObject {
    static let shared = LocalStorageService()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteMovieIds"
    
    @Published var favoriteMovieIds: Set<Int> = []
    
    init() {
        loadFavorites()
    }
    
    // MARK: - Favorites Management
    func addToFavorites(_ movieId: Int) {
        favoriteMovieIds.insert(movieId)
        saveFavorites()
    }
    
    func removeFromFavorites(_ movieId: Int) {
        favoriteMovieIds.remove(movieId)
        saveFavorites()
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        return favoriteMovieIds.contains(movieId)
    }
    
    func toggleFavorite(_ movieId: Int) {
        if isFavorite(movieId) {
            removeFromFavorites(movieId)
        } else {
            addToFavorites(movieId)
        }
    }
    
    // MARK: - Private Methods
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey) {
            do {
                let decoder = JSONDecoder()
                let ids = try decoder.decode([Int].self, from: data)
                favoriteMovieIds = Set(ids)
            } catch {
                print("Failed to load favorites: \(error)")
                favoriteMovieIds = []
            }
        }
    }
    
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(Array(favoriteMovieIds))
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
}

//
//  TMDbService.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
class TMDbService: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        
        // Load API key from Config.plist
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["APIKey"] as? String else {
            fatalError("TMDb API key not found in Config.plist")
        }
        
        self.apiKey = key
    }
    
    // MARK: - Popular Movies
    func fetchPopularMovies(page: Int = 1) async throws -> TMDbResponse {
        guard let url = buildURL(endpoint: "/movie/popular", queryItems: [
            URLQueryItem(name: "page", value: "\(page)")
        ]) else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.fetch(TMDbResponse.self, from: url)
    }
    
    // MARK: - Search Movies
    func searchMovies(query: String, page: Int = 1) async throws -> TMDbResponse {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let url = buildURL(endpoint: "/search/movie", queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
              ]) else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.fetch(TMDbResponse.self, from: url)
    }
    
    // MARK: - Movie Details
    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        guard let url = buildURL(endpoint: "/movie/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.fetch(MovieDetail.self, from: url)
    }
    
    // MARK: - Helper Methods
    private func buildURL(endpoint: String, queryItems: [URLQueryItem] = []) -> URL? {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            return nil
        }
        
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        items.append(contentsOf: queryItems)
        components.queryItems = items
        
        return components.url
    }
}

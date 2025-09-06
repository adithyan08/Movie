//
//  MovieModel.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import Foundation

// MARK: - Movie Model
struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
    }
    
    // Computed properties for display
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        return releaseDate
    }
    
    var formattedVoteAverage: String {
        return String(format: "%.1f", voteAverage)
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
    }
}



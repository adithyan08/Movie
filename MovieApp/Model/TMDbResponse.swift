//
//  TMDbResponse.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation

struct TMDbResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie Detail Model (Extended)
struct MovieDetail: Identifiable, Codable {
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
    let genres: [Genre]
    let runtime: Int?
    let budget: Int
    let revenue: Int
    let homepage: String?
    let imdbId: String?
    let tagline: String?
    let status: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let spokenLanguages: [SpokenLanguage]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, genres, runtime
        case budget, revenue, homepage, tagline, status
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case imdbId = "imdb_id"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var genreNames: String {
        genres.map { $0.name }.joined(separator: ", ")
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

// MARK: - Supporting Models
struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Identifiable, Codable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}

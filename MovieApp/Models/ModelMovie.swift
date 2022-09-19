//
//  ModelMovie.swift
//  MovieApp
//
//  Created by christian on 16/09/22.
//

import Foundation

struct Welcome: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
struct Movie: Codable {
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - Result
struct Result: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
struct Generos: Codable{
    let genres: [generosOpciones]
}

struct generosOpciones: Codable{
    let id: Int
    let name : String
}
struct Pelis: Decodable{
    let adult: Bool
    let backdrop_path, homepage, imdb_id, original_title, overview, poster_path: String
    let belongs_to_collection: String?
    let budget, id: Int
    let genres: [Genero]
    let original_language: String
}

struct Genero: Codable {
    let id: Int
    let name : String
}
struct resultados: Decodable{
    let results: [Movies]
}

struct Movies: Codable{
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
}



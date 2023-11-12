//
//  NewHotMoviesRepository.swift
//  Seminar2Solution
//
//  Created by user on 2023/10/07.
//

import Alamofire
import Foundation

struct NewHotMoviesRepository: BaseRepository {
    let session: Session

    func fetchUpcomingMovies(page: Int) async throws -> PaginatedMovieResponseDto {
        try await session.request("https://api.themoviedb.org/3/movie/upcoming?page=\(page)")
            .serializingDecodable(PaginatedMovieResponseDto.self, decoder: decoder)
            .value
    }

    func fetchPopularMovies(page: Int) async throws -> PaginatedMovieResponseDto {
        try await session.request("https://api.themoviedb.org/3/movie/popular?page=\(page)&region=KR")
            .serializingDecodable(PaginatedMovieResponseDto.self, decoder: decoder)
            .value
    }

    func fetchKeywords(for movieId: Int) async throws -> KeywordResponseDto {
        try await session.request("https://api.themoviedb.org/3/movie/\(movieId)/keywords")
            .serializingDecodable(KeywordResponseDto.self, decoder: decoder)
            .value
    }
}

protocol BaseRepository {
    var session: Session { get }
    var decoder: JSONDecoder { get }
}

extension BaseRepository {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

struct KeywordResponseDto: Codable {
    let id: Int
    let keywords: [KeywordDto]

}

struct KeywordDto: Codable {
    let id: Int
    let name: String
}

struct PaginatedMovieResponseDto: Codable {
    let totalPages: Int
    let totalResults: Int
    let page: Int
    let results: [MovieDto]
}

struct MovieDto: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String

    var posterAbsoluteURL: URL {
        let urlString = "https://image.tmdb.org/t/p/original/\(posterPath)"
        return URL(string: urlString)!
    }
}


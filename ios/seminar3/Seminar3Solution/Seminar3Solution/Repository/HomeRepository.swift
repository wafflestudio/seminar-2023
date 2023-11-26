//
//  HomeRepository.swift
//  Seminar3Solution
//
//  Created by user on 2023/10/28.
//

import Foundation
import Alamofire


struct HomeRepository: BaseRepository {
    let session: Session

    func fetchNowPlayingMovies(page: Int) async throws -> PaginatedMovieResponseDto {
        print("fetch page:\(page)")
        return try await session.request("https://api.themoviedb.org/3/movie/now_playing?page=\(page)")
            .serializingDecodable(PaginatedMovieResponseDto.self, decoder: decoder)
            .value
    }

    func fetchSearchResults(query: String) async throws -> PaginatedMovieResponseDto {
        do {
            return try await session.request("https://api.themoviedb.org/3/search/movie", parameters: ["query": query])
                .serializingDecodable(PaginatedMovieResponseDto.self, decoder: decoder)
                .value
        } catch {
            print(error)
            throw APIError.error
        }
    }


}
enum APIError: Error {
    case error
}

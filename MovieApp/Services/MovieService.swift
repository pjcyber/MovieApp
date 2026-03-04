//
//  MovieService.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

class MovieService: MovieServiceProtocol {
    static let shared = MovieService()

    private let apiKey: String
    private let client: MovieAPIClientProtocol

    init(apiKey: String? = AppConfig.tmdbApiKey, client: MovieAPIClientProtocol = MovieAPIClient()) {
        self.apiKey = apiKey ?? ""
        self.client = client
    }

    private func requireApiKey() throws {
        guard !apiKey.isEmpty else { throw MovieAPIError.missingApiKey }
    }

    func fetchNowPlaying(_ page: Int = 1) async throws -> MovieResponse {
        try requireApiKey()
        var components = URLComponents(string: "\(AppConfig.tmdbAPIBaseURL)/movie/now_playing")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = components?.url else {
            throw MovieAPIError.invalidURL
        }
        
        return try await client.fetchMovies(from: url)
    }
    
    func searchMovies(_ query: String, _ page: Int) async throws -> MovieResponse {
        try requireApiKey()
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            throw MovieAPIError.invalidURL
        }

        guard let queryEncoded = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MovieAPIError.invalidURL
        }

        var components = URLComponents(string: "\(AppConfig.tmdbAPIBaseURL)/search/movie")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "query", value: queryEncoded),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = components?.url else {
            throw MovieAPIError.invalidURL
        }
        
        return try await client.fetchMovies(from: url)
    }
}


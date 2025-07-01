//
//  MovieService.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

class MovieService: MovieServiceProtocol {
    static let shared = MovieService()  
    
    private let apiKey = "fb4b63165f5ce5680e1904b9cd40ba73"
    private let client: MovieAPIClientProtocol
    
    init(client: MovieAPIClientProtocol = MovieAPIClient()) {
        self.client = client
    }
    
    func fetchNowPlaying(_ page: Int = 1) async throws -> MovieResponse {
        var components = URLComponents(string: "https://api.themoviedb.org/3/movie/now_playing")
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
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If query is empty after trimming, return early with .invalidURL
        guard !trimmedQuery.isEmpty else {
            throw MovieAPIError.invalidURL
        }
        
        // Safely encode query
        guard let queryEncoded = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MovieAPIError.invalidURL
        }
        
        // Use URLComponents to build the URL properly
        var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie")
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


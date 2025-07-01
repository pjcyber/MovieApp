//
//  MovieService.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import Foundation

//class MovieService {
//    
//    static let shared = MovieService()  // Singelton
//    private let apiKey = "fb4b63165f5ce5680e1904b9cd40ba73"
//    
//    private let session: URLSession
//
//        // Inject custom URLSession for testing
//        init(session: URLSession = .shared) {
//            self.session = session
//        }
//    
//    func fetchNowPlaying(_ page: Int = 1) async -> (MovieResponse?, MovieAPIError?) {
//        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)") else {
//            return (nil, MovieAPIError.invalidURL)
//        }
//        
//        do {
//            let (data, response) = try await session.shared.data(from: url)
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200..<300).contains(httpResponse.statusCode) else {
//                return (nil, MovieAPIError.invalidResponse)
//            }
//            
//            do {
//                return try (JSONDecoder().decode(MovieResponse.self, from: data), nil)
//            } catch {
//                return (nil, MovieAPIError.decodingError(underlying: error))
//            }
//        } catch {
//            return (nil, MovieAPIError.networkError(error))
//        }
//    }
//    
//    
//    func searchMovies(_ query: String, page: Int = 1) async -> (MovieResponse?, MovieAPIError?) {
//        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        guard
//            let queryEncoded = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(queryEncoded)&page=\(page)")  else {
//            return (nil, MovieAPIError.invalidURL)
//        }
//        
//        do {
//            let (data, response) = try await session.shared.data(from: url)
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200..<300).contains(httpResponse.statusCode) else {
//                return (nil, MovieAPIError.invalidResponse)
//            }
//            
//            do {
//                return try (JSONDecoder().decode(MovieResponse.self, from: data), nil)
//            } catch {
//                return (nil, MovieAPIError.decodingError(underlying: error))
//            }
//        } catch {
//            return (nil, MovieAPIError.networkError(error))
//        }
//    }
//}

class MovieService: MovieServiceProtocol {
    static let shared = MovieService()  // Singleton
    
    private let apiKey = "fb4b63165f5ce5680e1904b9cd40ba73"
    private let session: URLSession

    // Inject custom URLSession for testing
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchNowPlaying(_ page: Int = 1) async -> (MovieResponse?, MovieAPIError?) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            return (nil, .invalidURL)
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                return (nil, .invalidResponse)
            }
            return try (JSONDecoder().decode(MovieResponse.self, from: data), nil)
        } catch {
            return (nil, .networkError(error))
        }
    }

    func searchMovies(_ query: String, _ page: Int) async -> (MovieResponse?, MovieAPIError?) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            let queryEncoded = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(queryEncoded)&page=\(page)")
        else {
            return (nil, .invalidURL)
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                return (nil, .invalidResponse)
            }
            return try (JSONDecoder().decode(MovieResponse.self, from: data), nil)
        } catch {
            return (nil, .networkError(error))
        }
    }
}


//
//  MovieAPIClient.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

final class MovieAPIClient: MovieAPIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchMovies(from url: URL) async throws -> MovieResponse {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw MovieAPIError.invalidResponse
        }

        do {
            return try decoder.decode(MovieResponse.self, from: data)
        } catch {
            throw MovieAPIError.decodingError(underlying: error)
        }
    }
}


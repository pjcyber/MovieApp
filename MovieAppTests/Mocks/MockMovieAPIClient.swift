//
//  MockMovieAPIClient.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation
@testable import MovieApp

final class MockMovieAPIClient: MovieAPIClientProtocol {
    var result: Result<MovieResponse, Error>

    init(result: Result<MovieResponse, Error>) {
        self.result = result
    }

    func fetchMovies(from url: URL) async throws -> MovieResponse {
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

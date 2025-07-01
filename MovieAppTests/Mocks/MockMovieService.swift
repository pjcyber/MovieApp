//
//  MockMovieService.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

class MockMovieService: MovieServiceProtocol {
    var fetchNowPlayingResult: MovieResponse = MovieResponse.fixture
    var searchMoviesResult: MovieResponse = MovieResponse.fixture

    func fetchNowPlaying(_ page: Int) async throws -> MovieResponse {
        return fetchNowPlayingResult
    }

    func searchMovies(_ query: String, _ page: Int) async throws -> MovieResponse{
        return searchMoviesResult
    }
}



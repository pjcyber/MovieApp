//
//  MockMovieService.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest
@testable import MovieApp

class MockMovieService: MovieServiceProtocol {
    var fetchNowPlayingResult: (MovieResponse?, MovieAPIError?) = (nil, nil)
    var searchMoviesResult: (MovieResponse?, MovieAPIError?) = (nil, nil)

    func fetchNowPlaying(_ page: Int) async -> (MovieResponse?, MovieAPIError?) {
        return fetchNowPlayingResult
    }

    func searchMovies(_ query: String, _ page: Int) async -> (MovieResponse?, MovieAPIError?) {
        return searchMoviesResult
    }
}



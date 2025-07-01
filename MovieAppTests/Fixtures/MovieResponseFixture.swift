//
//  MovieResponseFixture.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

extension MovieResponse {
    static var fixture: MovieResponse {
        return MovieResponse(
            page: 1,
            results: [Movie.fixture],
            totalPages: 2,
            totalResults: 1
        )
    }
}

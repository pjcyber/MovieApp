//
//  MovieTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

final class MovieTests: XCTestCase {

    func testMovieDecoding() throws {
        let json = """
        {
            "id": 123,
            "title": "Test Movie",
            "overview": "This is a test overview.",
            "poster_path": "/poster.jpg",
            "vote_average": 8.5,
            "vote_count": 2000
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let movie = try decoder.decode(Movie.self, from: json)

        XCTAssertEqual(movie.id, 123)
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.overview, "This is a test overview.")
        XCTAssertEqual(movie.posterPath, "/poster.jpg")
        XCTAssertEqual(movie.voteAverage, 8.5)
        XCTAssertEqual(movie.voteCount, 2000)
    }

    func testMovieDecodingWithMissingOptionalFields() throws {
        let json = """
        {
            "id": 456,
            "title": "Missing Fields Movie",
            "overview": "This has no optional fields."
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let movie = try decoder.decode(Movie.self, from: json)

        XCTAssertEqual(movie.id, 456)
        XCTAssertEqual(movie.title, "Missing Fields Movie")
        XCTAssertEqual(movie.overview, "This has no optional fields.")
        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.voteAverage)
        XCTAssertNil(movie.voteCount)
    }
}


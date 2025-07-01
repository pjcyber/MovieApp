//
//  MovieResponseTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest
@testable import MovieApp 

final class MovieResponseTests: XCTestCase {

    func testMovieResponseDecoding() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 101,
                    "title": "Sample Movie",
                    "overview": "Sample overview text.",
                    "poster_path": "/sample.jpg",
                    "vote_average": 7.2,
                    "vote_count": 1234
                },
                {
                    "id": 102,
                    "title": "Another Movie",
                    "overview": "Another overview.",
                    "poster_path": "/another.jpg",
                    "vote_average": 6.5,
                    "vote_count": 4321
                }
            ],
            "total_pages": 10,
            "total_results": 100
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(MovieResponse.self, from: json)

        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.totalPages, 10)
        XCTAssertEqual(response.totalResults, 100)
        XCTAssertEqual(response.results.count, 2)

        let firstMovie = response.results[0]
        XCTAssertEqual(firstMovie.id, 101)
        XCTAssertEqual(firstMovie.title, "Sample Movie")
        XCTAssertEqual(firstMovie.posterPath, "/sample.jpg")
    }

    func testMovieResponseWithEmptyResults() throws {
        let json = """
        {
            "page": 2,
            "results": [],
            "total_pages": 10,
            "total_results": 100
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(MovieResponse.self, from: json)

        XCTAssertEqual(response.page, 2)
        XCTAssertEqual(response.results, [])
        XCTAssertEqual(response.totalPages, 10)
        XCTAssertEqual(response.totalResults, 100)
    }
}


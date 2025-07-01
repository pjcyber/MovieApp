//
//  MovieServiceTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest
@testable import MovieApp

final class MovieServiceTests: XCTestCase {

    var movieService: MovieService!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        movieService = MovieService(session: session)
    }

    func testFetchNowPlayingSuccess() async throws {
        let mockJSON = """
        {
            "page": 1,
            "results": [{
                "id": 1,
                "title": "Test Movie",
                "overview": "Overview here.",
                "poster_path": "/poster.jpg",
                "vote_average": 7.5,
                "vote_count": 1000
            }],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockResponseData = mockJSON
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)

        let (response, error) = await movieService.fetchNowPlaying()

        XCTAssertNil(error)
        XCTAssertEqual(response?.page, 1)
        XCTAssertEqual(response?.results.count, 1)
        XCTAssertEqual(response?.results.first?.title, "Test Movie")
    }

    func testFetchNowPlayingNilResponse() async throws {
        MockURLProtocol.mockResponseData = Data()
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 500,
                                                       httpVersion: nil,
                                                       headerFields: nil)

        let (response, error) = await movieService.fetchNowPlaying()
        XCTAssertNil(response)
    }
}

//
//  MovieServiceTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

final class MovieServiceTests: XCTestCase {
    
    func testFetchNowPlayingReturnsSuccess() async throws {
        // Given
        let mockClient = MockMovieAPIClient(result: .success(MovieResponse.fixture))
        let service = MovieService(client: mockClient)

        // When
        let result = try await service.fetchNowPlaying()

        // Then
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.results.count, 1)
    }

    func testFetchNowPlayingThrowsError() async {
        // Given
        let mockClient = MockMovieAPIClient(result: .failure(MovieAPIError.invalidResponse))
        let service = MovieService(client: mockClient)

        // When
        do {
            _ = try await service.fetchNowPlaying()
            XCTFail("Expected to throw, but did not")
        } catch {
            // Then
            XCTAssertTrue(error is MovieAPIError)
        }
    }
    
    func testSearchMoviesReturnsSuccess() async throws {
        // Given
        let expectedResponse = MovieResponse.fixture

        let mockClient = MockMovieAPIClient(result: .success(MovieResponse.fixture))
        let service = MovieService(client: mockClient)

        // When
        let response = try await service.searchMovies("Inception", 1)

        // Then
        XCTAssertEqual(response.results.first?.title, expectedResponse.results.first?.title)
    }
    
    func testSearchMoviesWithInvalidQueryThrowsInvalidURLError() async throws {
        // Given
        let mockClient = MockMovieAPIClient(result: .failure(MovieAPIError.invalidResponse))
        let service = MovieService(client: mockClient)
        let brokenQuery = ""

        // When / Then
        do {
            _ = try await service.searchMovies(brokenQuery, 1)
            XCTFail("Expected to throw invalidURL error, but did not")
        } catch let error as MovieAPIError {
            XCTAssertEqual(error.errorDescription, MovieAPIError.invalidURL.errorDescription)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

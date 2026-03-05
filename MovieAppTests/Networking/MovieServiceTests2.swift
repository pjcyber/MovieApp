//
//  MovieServiceTests2.swift
//  MovieAppTests
//
//  Swift Testing variant of MovieServiceTests.
//

import Testing
@testable import MovieApp

struct MovieServiceTests2 {

    @Test func fetchNowPlayingReturnsSuccess() async throws {
        // Given
        let mockClient = MockMovieAPIClient(result: .success(MovieResponse.fixture))
        let service = MovieService(apiKey: "test_key", client: mockClient)

        // When
        let result = try await service.fetchNowPlaying()

        // Then
        #expect(result.page == 1)
        #expect(result.results.count == 1)
    }

    @Test func fetchNowPlayingThrowsError() async {
        // Given
        let mockClient = MockMovieAPIClient(result: .failure(MovieAPIError.invalidResponse))
        let service = MovieService(apiKey: "test_key", client: mockClient)

        // When / Then
        do {
            _ = try await service.fetchNowPlaying()
            #expect(Bool(false), "Expected to throw, but did not")
        } catch {
            #expect(error is MovieAPIError)
        }
    }

    @Test func searchMoviesReturnsSuccess() async throws {
        // Given
        let expectedResponse = MovieResponse.fixture
        let mockClient = MockMovieAPIClient(result: .success(MovieResponse.fixture))
        let service = MovieService(apiKey: "test_key", client: mockClient)

        // When
        let response = try await service.searchMovies("Inception", 1)

        // Then
        #expect(response.results.first?.title == expectedResponse.results.first?.title)
    }

    @Test func searchMoviesWithInvalidQueryThrowsInvalidURLError() async {
        // Given
        let mockClient = MockMovieAPIClient(result: .failure(MovieAPIError.invalidResponse))
        let service = MovieService(apiKey: "test_key", client: mockClient)
        let brokenQuery = ""

        // When / Then
        do {
            _ = try await service.searchMovies(brokenQuery, 1)
            #expect(Bool(false), "Expected to throw, but did not")
        } catch let error as MovieAPIError {
            #expect(error.errorDescription == MovieAPIError.invalidURL.errorDescription)
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
}

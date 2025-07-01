//
//  MovieViewModelTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest
@testable import MovieApp


final class MovieViewModelTests: XCTestCase {

    @MainActor
    func testLoadMoviesAppendsResults() async {
        let mockService = MockMovieService()
        mockService.fetchNowPlayingResult = (
            MovieResponse(
                page: 1,
                results: [
                    Movie(id: 1, title: "Test Movie", overview: "Overview", posterPath: nil, voteAverage: 8.0, voteCount: 100)
                ],
                totalPages: 2,
                totalResults: 1
            ),
            nil
        )

        let viewModel = MovieViewModel(movieService: mockService)

        await viewModel.loadMovies()

        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Test Movie")
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(viewModel.totalPages, 2)
    }

    @MainActor
    func testFilterMoviesReturnsFilteredResults() async {
        let mockService = MockMovieService()
        mockService.searchMoviesResult = (
            MovieResponse(
                page: 1,
                results: [
                    Movie(id: 99, title: "Filtered", overview: "filtered movie", posterPath: nil, voteAverage: 7.5, voteCount: 50)
                ],
                totalPages: 1,
                totalResults: 1
            ),
            nil
        )

        let viewModel = MovieViewModel(movieService: mockService)
        viewModel.searchText = "Filtered"

        await viewModel.filterMovies()

        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.id, 99)
    }

    @MainActor
    func testLoadMoviesSkipsWhenAlreadyLoading() async {
        let mockService = MockMovieService()
        let viewModel = MovieViewModel(movieService: mockService)
        viewModel.isLoading = true

        await viewModel.loadMovies()

        XCTAssertTrue(viewModel.movies.isEmpty)
    }
}

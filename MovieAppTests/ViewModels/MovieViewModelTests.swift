//
//  MovieViewModelTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp


final class MovieViewModelTests: XCTestCase {

    @MainActor
    func testLoadMoviesAppendsResults() async {
        let mockService = MockMovieService()
        mockService.fetchNowPlayingResult = MovieResponse.fixture

        let viewModel = MovieViewModel(movieService: mockService)

        await viewModel.loadMovies()

        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "test")
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(viewModel.totalPages, 2)
    }

    @MainActor
    func testFilterMoviesReturnsFilteredResults() async {
        let mockService = MockMovieService()
        mockService.searchMoviesResult = MovieResponse.fixture
        

        let viewModel = MovieViewModel(movieService: mockService)
        viewModel.searchText = "Filtered"

        await viewModel.filterMovies()

        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.id, 1)
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

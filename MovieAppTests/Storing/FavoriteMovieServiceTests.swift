//
//  FavoriteMovieServiceTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
import SwiftData
@testable import MovieApp

final class FavoriteMovieServiceTests: XCTestCase {

    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var service: FavoriteMovieService!

    override func setUpWithError() throws {
        service = FavoriteMovieService.shared
        modelContainer = try ModelContainer(
            for: FavoriteMovie.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        modelContext = ModelContext(modelContainer)
    }

    func testSaveFavoriteMovie() throws {
        let movie = FavoriteMovie(
            orgintalId: 101,
            overview: "A test movie",
            posterPath: "/test.jpg",
            title: "Test Title",
            voteAverage: 8.1,
            voteCount: 200
        )

        try service.saveMovie(favoriteMovie: movie, context: modelContext)

        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.orgintalId == 101 }
        )

        let fetched = try modelContext.fetch(descriptor)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "Test Title")
    }

    func testIsFavoriteMovieReturnsTrue() throws {
        let movie = FavoriteMovie(
            orgintalId: 202,
            overview: "Another movie",
            posterPath: nil,
            title: "Favorite Check",
            voteAverage: nil,
            voteCount: nil
        )

        try service.saveMovie(favoriteMovie: movie, context: modelContext)

        let isFav = try service.isFavoriteMovie(movieId: 202, modelContext: modelContext)
        XCTAssertTrue(isFav)
    }

    func testIsFavoriteMovieReturnsFalse() throws {
        let isFav = try service.isFavoriteMovie(movieId: 999, modelContext: modelContext)
        XCTAssertFalse(isFav)
    }

    func testDeleteFavoriteMovie() throws {
        let movie = FavoriteMovie(
            orgintalId: 303,
            overview: "To be deleted",
            posterPath: nil,
            title: "Delete Test",
            voteAverage: nil,
            voteCount: nil
        )

        try service.saveMovie(favoriteMovie: movie, context: modelContext)
        try service.deleteMovie(movieId: 303, modelContext: modelContext)

        let isFav = try service.isFavoriteMovie(movieId: 303, modelContext: modelContext)
        XCTAssertFalse(isFav)
    }
}


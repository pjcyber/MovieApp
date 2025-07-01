//
//  FavoriteMovieTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest
import SwiftData
@testable import MovieApp

final class FavoriteMovieTests: XCTestCase {

    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUpWithError() throws {
        modelContainer = try ModelContainer(for: FavoriteMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        modelContext = ModelContext(modelContainer)
    }

    func testInsertAndFetchFavoriteMovie() throws {
        // Create movie
        let movie = FavoriteMovie(
            orgintalId: 101,
            overview: "A great movie",
            posterPath: "/poster.jpg",
            title: "Test Title",
            voteAverage: 8.8,
            voteCount: 999
        )

        // Save it
        modelContext.insert(movie)
        try modelContext.save()

        // Fetch it
        let descriptor = FetchDescriptor<FavoriteMovie>()
        let fetched = try modelContext.fetch(descriptor)

        XCTAssertEqual(fetched.count, 1)

        let fetchedMovie = fetched.first!
        XCTAssertEqual(fetchedMovie.orgintalId, 101)
        XCTAssertEqual(fetchedMovie.title, "Test Title")
        XCTAssertEqual(fetchedMovie.overview, "A great movie")
        XCTAssertEqual(fetchedMovie.posterPath, "/poster.jpg")
        XCTAssertEqual(fetchedMovie.voteAverage, 8.8)
        XCTAssertEqual(fetchedMovie.voteCount, 999)
    }

    func testInsertMultipleFavorites() throws {
        let movies = [
            FavoriteMovie(orgintalId: 1, overview: "First", posterPath: nil, title: "One", voteAverage: nil, voteCount: nil),
            FavoriteMovie(orgintalId: 2, overview: "Second", posterPath: "/img.jpg", title: "Two", voteAverage: 5.5, voteCount: 300)
        ]

        for movie in movies {
            modelContext.insert(movie)
        }
        try modelContext.save()

        let fetched = try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
        XCTAssertEqual(fetched.count, 2)
    }
}


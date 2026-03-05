//
//  FavoriteMovieViewModelTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
import SwiftData
@testable import MovieApp

final class FavoriteMovieViewModelTests: XCTestCase {
    
    var container: ModelContainer!
    var context: ModelContext!
    var viewModel: FavoriteMovieViewModel!

    @MainActor
    override func setUpWithError() throws {
        container = try ModelContainer(
            for: FavoriteMovie.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(container)
        viewModel = FavoriteMovieViewModel()
    }

    @MainActor
    func testStoreFavoriteMovie() {
        let movie = FavoriteMovie(
            originalId: 123,
            overview: "Test Overview",
            posterPath: "/test.jpg",
            title: "Test Movie",
            voteAverage: 7.5,
            voteCount: 300
        )
        
        viewModel.saveFavoriteMovie(favoriteMovie: movie, modelContext: context)

        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.originalId == 123 }
        )
        let fetched = try? context.fetch(descriptor)

        XCTAssertEqual(fetched?.count, 1)
        XCTAssertEqual(fetched?.first?.title, "Test Movie")
    }

    @MainActor
    func testDeleteFavoriteMovie() {
        let movie = FavoriteMovie(
            originalId: 456,
            overview: "To be deleted",
            posterPath: nil,
            title: "Delete Me",
            voteAverage: nil,
            voteCount: nil
        )
        
        viewModel.saveFavoriteMovie(favoriteMovie: movie, modelContext: context)
        viewModel.deleteFavoriteMovie(movieId: 456, modelContext: context)

        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.originalId == 456 }
        )
        let fetched = try? context.fetch(descriptor)

        XCTAssertEqual(fetched?.count, 0)
    }

    @MainActor
    func testIsFavoriteMovie() {
        let movie = FavoriteMovie(
            originalId: 789,
            overview: "Favorite check",
            posterPath: nil,
            title: "Fav Test",
            voteAverage: nil,
            voteCount: nil
        )
        
        XCTAssertFalse(viewModel.isFavoriteMovie(movieId: 789, modelContext: context))
        
        viewModel.saveFavoriteMovie(favoriteMovie: movie, modelContext: context)
        
        XCTAssertTrue(viewModel.isFavoriteMovie(movieId: 789, modelContext: context))
    }
}


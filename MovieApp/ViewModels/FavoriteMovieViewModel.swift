//
//  FavoriteMovieViewModel.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation
import SwiftData

@MainActor
class FavoriteMovieViewModel: ObservableObject {

    @Published var errorMessage: String?

    func clearError() {
        errorMessage = nil
    }

    func storeFavoriteMovie(favoriteMovie: FavoriteMovie, modelContext: ModelContext) {
        do {
            try FavoriteMovieService.shared.saveMovie(favoriteMovie: favoriteMovie, context: modelContext)
        } catch {
            errorMessage = String(localized: "Failed to save favorite: \(error.localizedDescription)")
        }
    }

    func deleteFavoriteMovie(movieId: Int, modelContext: ModelContext) {
        do {
            try FavoriteMovieService.shared.deleteMovie(movieId: movieId, modelContext: modelContext)
        } catch {
            errorMessage = String(localized: "Failed to remove favorite: \(error.localizedDescription)")
        }
    }

    /// Toggle favorite state for the given movie. Use after checking current state with @Query or isFavoriteMovie.
    func toggle(movie: Movie, modelContext: ModelContext) {
        do {
            let isFav = try FavoriteMovieService.shared.isFavoriteMovie(movieId: movie.id, modelContext: modelContext)
            if isFav {
                try FavoriteMovieService.shared.deleteMovie(movieId: movie.id, modelContext: modelContext)
            } else {
                let fav = FavoriteMovie(
                    originalId: movie.id,
                    overview: movie.overview,
                    posterPath: movie.posterPath,
                    title: movie.title,
                    voteAverage: movie.voteAverage,
                    voteCount: movie.voteCount
                )
                try FavoriteMovieService.shared.saveMovie(favoriteMovie: fav, context: modelContext)
            }
        } catch {
            errorMessage = String(localized: "Failed to update favorite: \(error.localizedDescription)")
        }
    }

    func isFavoriteMovie(movieId: Int, modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.originalId == movieId }
        )
        do {
            let favoriteMovies = try modelContext.fetch(descriptor)
            return !favoriteMovies.isEmpty
        } catch {
            return false
        }
    }
}

//
//  FavoriteMovieViewModel.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 30/06/25.
//

import Foundation
import SwiftData

@MainActor
class FavoriteMovieViewModel: ObservableObject {
    
    func storeFavoriteMovie(favoriteMovie: FavoriteMovie, modelContext: ModelContext) {
        do {
            try FavoriteMovieService.shared.saveMovie(favoriteMovie: favoriteMovie, context: modelContext)
        } catch let error {
            print("Fail sotre favorite movie \(error.localizedDescription)")
        }
    }
    
    func deleteFavoriteMovie(movieId: Int, modelContext: ModelContext) {
        do {
            try FavoriteMovieService.shared.deleteMovie(movieId: movieId, modelContext: modelContext)
        } catch let error {
            print("Fail delete favorite movie \(error.localizedDescription)")
        }
    }
    
    func isFavoriteMovie(movieId: Int, modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<FavoriteMovie>(
                predicate: #Predicate { $0.orgintalId == movieId}
        )
        do {
            let favoriteMovies = try modelContext.fetch(descriptor)
            return !favoriteMovies.isEmpty
        } catch let error {
            return false
        }
    }
}

//
//  StorageService.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 30/06/25.
//

import Foundation
import SwiftData

class FavoriteMovieService {
    
    static let shared = FavoriteMovieService()


    func saveMovie(favoriteMovie: FavoriteMovie, context: ModelContext) throws {
        context.insert(favoriteMovie)
        try context.save()
    }
    
    func deleteMovie(movieId: Int, modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.orgintalId == movieId}
        )
    
        let favoriteMovies = try modelContext.fetch(descriptor)
        if let favMovie = favoriteMovies.first {
            modelContext.delete(favMovie)
        }
    }
    
    func isFavoriteMovie(movieId: Int, modelContext: ModelContext) throws  -> Bool {
        let descriptor = FetchDescriptor<FavoriteMovie>(
                predicate: #Predicate { $0.orgintalId == movieId}
        )
        let favoriteMovies = try modelContext.fetch(descriptor)
        return !favoriteMovies.isEmpty
    }
}

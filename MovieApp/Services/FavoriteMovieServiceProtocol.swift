//
//  FavoriteMovieServiceProtocol.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation
import SwiftData

protocol FavoriteMovieServiceProtocol {
    func saveMovie(favoriteMovie: FavoriteMovie, context: ModelContext) throws
    func deleteMovie(movieId: Int, modelContext: ModelContext) throws
    func isFavoriteMovie(movieId: Int, modelContext: ModelContext) throws  -> Bool
}

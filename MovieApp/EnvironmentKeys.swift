//
//  EnvironmentKeys.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI

private struct MovieServiceKey: EnvironmentKey {
    static let defaultValue: MovieService = MovieService()
}

private struct AppRouterKey: EnvironmentKey {
    static let defaultValue: AppRouter = AppRouter()
}

private struct FavoriteMovieViewModelKey: EnvironmentKey {
    static let defaultValue: FavoriteMovieViewModel? = nil
}

extension EnvironmentValues {
    var movieService: MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }

    var appRouter: AppRouter {
        get { self[AppRouterKey.self] }
        set { self[AppRouterKey.self] = newValue }
    }

    var favoriteMovieViewModel: FavoriteMovieViewModel? {
        get { self[FavoriteMovieViewModelKey.self] }
        set { self[FavoriteMovieViewModelKey.self] = newValue }
    }
}

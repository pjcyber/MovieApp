//
//  FavoriteMoviesScreenView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct FavoriteMoviesScreenView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appRouter) private var router
    @Environment(\.favoriteMovieViewModel) private var favoriteViewModel
    @Query(sort: \FavoriteMovie.title) private var favoriteMovies: [FavoriteMovie]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            if favoriteMovies.isEmpty {
                EmptyStateView(
                    systemImageName: "heart.slash",
                    message: String(localized: "No favorite movies yet. Add some from the list.")
                )
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(favoriteMovies) { favoriteMovie in
                        let movie = Movie(
                            id: favoriteMovie.originalId,
                            title: favoriteMovie.title,
                            overview: favoriteMovie.overview,
                            posterPath: favoriteMovie.posterPath,
                            voteAverage: favoriteMovie.voteAverage,
                            voteCount: favoriteMovie.voteCount
                        )
                        MovieGridItemView(
                            movie: movie,
                            isFavorite: true,
                            onToggleFavorite: { favoriteViewModel?.toggle(movie: movie, modelContext: modelContext) }
                        )
                        .onTapGesture { router.push(.movieDetail(movie)) }
                        .accessibilityIdentifier("movieGridItemView")
                    }
                }
                .padding()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "Favorite movies list"))
        .navigationTitle(String(localized: "Favorite Movies"))
        .favoriteErrorAlert(viewModel: favoriteViewModel)
    }
}

// MARK: - Preview
struct FavoriteMoviesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMoviesScreenView()
    }
}

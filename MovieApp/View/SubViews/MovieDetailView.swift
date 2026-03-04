//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {

    let movie: Movie

    @Environment(\.modelContext) private var modelContext
    @Environment(\.favoriteMovieViewModel) private var favoriteViewModel
    @Query(sort: \FavoriteMovie.title) private var favoriteMovies: [FavoriteMovie]

    private var isFavorite: Bool {
        favoriteMovies.contains { $0.originalId == movie.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if movie.posterPath != nil {
                    HStack {
                        Spacer()
                        MovieCardView(
                            movie: movie,
                            width: 200,
                            height: 300,
                            isFavorite: isFavorite,
                            onToggleFavorite: { favoriteViewModel?.toggle(movie: movie, modelContext: modelContext) }
                        )
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
                            VoteProgressView(voteAverage: voteAverage, voteCount: voteCount)
                        }
                        Text(movie.title)
                            .font(.title)
                            .bold()
                            .padding(.horizontal)
                            .accessibilityIdentifier("movieDetailTitle")
                        Spacer()
                    }
                    Text(movie.overview)
                        .font(.body)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "Movie detail for \(movie.title)"))
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .favoriteErrorAlert(viewModel: favoriteViewModel)
    }
}

// MARK: - Preview
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(id: 1, title: "test", overview: "overview", posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg", voteAverage: 7.557, voteCount: 6566)
        MovieDetailView(movie: movie)
    }
}

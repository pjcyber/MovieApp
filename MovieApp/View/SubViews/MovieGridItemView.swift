//
//  MovieGridItemView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI

struct MovieGridItemView: View {

    let movie: Movie
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack {
            if movie.posterPath != nil {
                MovieCardView(
                    movie: movie,
                    width: nil,
                    height: 250,
                    isFavorite: isFavorite,
                    onToggleFavorite: onToggleFavorite
                )
            }
            Text(movie.title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding([.top, .horizontal], 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(movie.title)
        .accessibilityHint(String(localized: "Double tap to open details"))
    }
}

// MARK: - Preview
struct MovieGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(
            id: 1,
            title: "test",
            overview: "overview",
            posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg",
            voteAverage: 7.557,
            voteCount: 6566
        )
        MovieGridItemView(movie: movie, isFavorite: false, onToggleFavorite: {})
    }
}

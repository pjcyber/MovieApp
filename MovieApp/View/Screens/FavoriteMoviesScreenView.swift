//
//  MyFavoriteMoviesScreenView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 30/06/25.
//

import SwiftUI
import SwiftData

struct FavoriteMoviesScreenView: View {
    
    @Query(sort: \FavoriteMovie.title) var favoriteMovies: [FavoriteMovie]
    @State private var selectedMovie: Movie?
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(favoriteMovies) { favoriteMovie in
                        let movie = Movie(id: favoriteMovie.orgintalId, title: favoriteMovie.title, overview: favoriteMovie.overview, posterPath: favoriteMovie.posterPath, voteAverage: favoriteMovie.voteAverage, voteCount: favoriteMovie.voteCount
                        )
                        
                        MovieGridItemView(movie: movie)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                            .accessibilityIdentifier("movieGridItemView")
                    }
                }
                .padding()
            }
            .navigationTitle("Favorite Movies")
            .navigationDestination(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}

//// MARK: - Preview
struct FavoriteMoviesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMoviesScreenView()
    }
}

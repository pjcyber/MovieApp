//
//  FavoriteButton.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct FavoriteButton: View {
    
    @State private var isLiked = false
    @StateObject private var viewModel = FavoriteMovieViewModel()
    @Environment(\.modelContext) private var modelContext
    
    let movie: Movie
    
    var body: some View {
        Button(action: {
            withAnimation {
                isLiked.toggle()
            }
            let favMovie = FavoriteMovie(orgintalId: movie.id, overview: movie.overview, posterPath: movie.posterPath, title: movie.title, voteAverage: movie.voteAverage, voteCount: movie.voteCount)
            if (isLiked) {
                viewModel.storeFavoriteMovie(favoriteMovie: favMovie, modelContext: modelContext)
            } else {
                viewModel.deleteFavoriteMovie(movieId: movie.id, modelContext: modelContext)
            }
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isLiked ? .red : .white)
                .padding(8)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
        }
        .padding(10)
        .buttonStyle(PlainButtonStyle())
        .task {
            isLiked = viewModel.isFavoriteMovie(movieId: movie.id, modelContext: modelContext)
        }
    }
}

// MARK: - Preview
struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(
            id: 1,
            title: "test",
            overview: "overview",
            posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg",
            voteAverage: 7.557,
            voteCount: 6566
        )
        FavoriteButton(movie: movie)
    }
}

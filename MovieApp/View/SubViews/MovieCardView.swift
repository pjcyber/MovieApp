//
//  MovieCardView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct MovieCardView: View {
    // Params
    let movie: Movie
    let width: CGFloat?
    let height: CGFloat?
   
    @State private var favoriteMovies: [FavoriteMovie] = []

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let path = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: width, height: height)
                            .clipped()
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    case .failure:
                        Color.gray
                            .frame(width: width, height: height)
                            .overlay(
                                Text("No Image")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            )
                    case .empty:
                        ProgressView()
                            .frame(width: width, height: height)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                FavoriteButton(
                    movie: movie
                )
            }
        }
    }
}

// MARK: - Preview
struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(id: 1,title: "test", overview: "overview", posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg", voteAverage: 7.557 , voteCount: 6566)
        MovieCardView(movie: movie, width: 200, height: 300)
    }
}


//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie
    @State private var isLiked: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Poster
                    if let _ = movie.posterPath {
                        HStack {
                            Spacer()
                            MovieCardView(movie: movie, width: 200, height: 300)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
                                VoteProgressView(voteAverage: voteAverage, voteCount: voteCount)
                            }
                            Spacer()
                            Text(movie.title)
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                                .accessibilityIdentifier("movieDetailTitle")
                        
                            Spacer()
                        }
                        Spacer()
                        
                        Text(movie.overview)
                                .font(.body)
                                .padding(.horizontal)
                        

                        Spacer()
               
                .navigationTitle(movie.title)
                .navigationBarTitleDisplayMode(.inline)
                    }
            }
            .padding(.top)
        }
    }
}

// MARK: - Preview
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(id: 1,title: "test", overview: "overview", posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg", voteAverage: 7.557 , voteCount: 6566)
        MovieDetailView(movie: movie)
    }
}


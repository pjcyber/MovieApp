//
//  MovieGridItemView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import SwiftUI


struct MovieGridItemView: View {
    let movie: Movie
    
    var body: some View {
            VStack {
                if let _ = movie.posterPath {
                    MovieCardView(movie: movie, width: nil, height: 250.00)
                }
                Text(movie.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding([.top, .horizontal], 4)
            }
        
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
        MovieGridItemView(movie: movie)
    }
}

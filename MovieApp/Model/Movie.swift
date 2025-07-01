//
//  Movie.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import Foundation

struct Movie: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//
//  Movie.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import Foundation

struct Movie: Decodable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
}

//
//  Movie.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
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

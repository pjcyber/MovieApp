//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

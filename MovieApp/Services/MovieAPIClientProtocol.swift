//
//  MovieAPIClientProtocol.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 1/07/25.
//

import Foundation

protocol MovieAPIClientProtocol {
    func fetchMovies(from url: URL) async throws -> MovieResponse
}

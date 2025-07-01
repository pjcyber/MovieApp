//
//  MovieServiceProtocol.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchNowPlaying(_ page: Int) async throws -> MovieResponse
    func searchMovies(_ query: String, _ page: Int) async throws -> MovieResponse
}

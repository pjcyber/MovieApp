//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation
import SwiftData

@MainActor
class MovieViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var movies: [Movie] = []
    
    var isLoading = false
    var currentPage = 1
    var totalPages = 1
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService.shared) {
        self.movieService = movieService
    }
    
    func loadMovies(reset: Bool = false) async {
        guard !isLoading else { return }
        if reset {
            resetInitParams()
        }
        
        guard currentPage <= totalPages else { return }
        
        isLoading = true
        do {
            let response =  try await movieService.fetchNowPlaying(currentPage)
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        } catch let error {
            handleError(error)
        }
        isLoading = false
    }
    
    func filterMovies() async {
        guard !isLoading else { return }
        
        resetInitParams()
        
        guard currentPage <= totalPages else { return }
        
        isLoading = true
        do {
            let response  = try await movieService.searchMovies(searchText, 1)
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        } catch let error {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func resetInitParams() {
        currentPage = 1
        totalPages = 1
        movies = []
    }
    
    func handleError(_ error: Error) {
        if let movieError = error as? MovieAPIError {
            print("MovieAPIError: \(movieError.errorDescription)")
        } else if let decodingError = error as? DecodingError {
            print("DecodingError: \(decodingError)")
        } else if let urlError = error as? URLError {
            print(" RLError: \(urlError)")
        } else {
            print("Unknown error type: \(error)")
        }
    }
    
}


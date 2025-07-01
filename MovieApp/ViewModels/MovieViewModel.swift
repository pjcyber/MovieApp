//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
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
        
        let (data, movieApiError) =  await movieService.fetchNowPlaying(currentPage)
        if let err = movieApiError {
            
        }
        
        if let response = data{
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        }
        isLoading = false
    }
    
    func filterMovies() async {
        guard !isLoading else { return }
        
        resetInitParams()
        
        guard currentPage <= totalPages else { return }
        
        isLoading = true
        
        let (data, movieApiError)  = await movieService.searchMovies(searchText, 1)
        if let err = movieApiError {
            
        }
        if let response = data{
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        }
        
        isLoading = false
    }
    
    private func resetInitParams() {
        currentPage = 1
        totalPages = 1
        movies = []
    }
    
}


//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

@MainActor
class MovieViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var currentPage = 1
    var totalPages = 1

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol = MovieService.shared) {
        self.movieService = movieService
    }

    func clearError() {
        errorMessage = nil
    }

    func loadMovies(reset: Bool = false) async {
        guard !isLoading else { return }
        if reset {
            resetInitParams()
        }

        guard currentPage <= totalPages else { return }

        isLoading = true
        errorMessage = nil
        do {
            let response = try await movieService.fetchNowPlaying(currentPage)
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        } catch {
            errorMessage = message(for: error)
        }
        isLoading = false
    }

    func filterMovies() async {
        guard !isLoading else { return }

        resetInitParams()

        guard currentPage <= totalPages else { return }

        isLoading = true
        errorMessage = nil
        do {
            let response = try await movieService.searchMovies(searchText, 1)
            movies += response.results
            totalPages = response.totalPages
            currentPage += 1
        } catch {
            errorMessage = message(for: error)
        }
        isLoading = false
    }

    private func resetInitParams() {
        currentPage = 1
        totalPages = 1
        movies = []
    }

    private func message(for error: Error) -> String {
        if let movieError = error as? MovieAPIError {
            return movieError.errorDescription
        }
        if let urlError = error as? URLError {
            return urlError.localizedDescription
        }
        return error.localizedDescription
    }
}


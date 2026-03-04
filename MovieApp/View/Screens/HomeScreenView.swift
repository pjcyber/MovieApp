//
//  HomeScreenView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct HomeScreenView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteMovie.title) private var favoriteMovies: [FavoriteMovie]

    @Environment(\.appRouter) private var router
    @Environment(\.favoriteMovieViewModel) private var favoriteViewModel
    @StateObject private var viewModel: MovieViewModel
    @State private var searchTask: Task<Void, Never>?

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    init(movieService: MovieServiceProtocol = MovieService()) {
        _viewModel = StateObject(wrappedValue: MovieViewModel(movieService: movieService))
    }

    private var favoriteIds: Set<Int> {
        Set(favoriteMovies.map(\.originalId))
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let movie = viewModel.movies[index]
                    if movie.posterPath != nil {
                        MovieGridItemView(
                            movie: movie,
                            isFavorite: favoriteIds.contains(movie.id),
                            onToggleFavorite: { favoriteViewModel?.toggle(movie: movie, modelContext: modelContext) }
                        )
                        .onAppear {
                            if index == viewModel.movies.count - 1 {
                                Task { await viewModel.loadMovies() }
                            }
                        }
                        .onTapGesture { router.push(.movieDetail(movie)) }
                        .accessibilityIdentifier("movieGridItemView")
                    }
                }
            }
            .padding()

            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .accessibilityLabel(String(localized: "Loading"))
            }

            if !viewModel.isLoading && viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                emptyStateView
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "Now playing movies list"))
        .navigationTitle(String(localized: "Now Playing"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        router.push(.favorites)
                    } label: {
                        Label(String(localized: "Favorite Movies"), systemImage: "heart")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .imageScale(.large)
                        .accessibilityLabel(String(localized: "Menu"))
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .onChange(of: viewModel.searchText) { _, newValue in
            searchTask?.cancel()
            if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Task { await viewModel.loadMovies(reset: true) }
                return
            }
            searchTask = Task {
                try? await Task.sleep(nanoseconds: AppConfig.searchDebounceNanoseconds)
                guard !Task.isCancelled else { return }
                await viewModel.filterMovies()
            }
        }
        .task {
            await viewModel.loadMovies()
        }
        .alert(String(localized: "Error"), isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button(String(localized: "Retry")) {
                viewModel.clearError()
                Task {
                    if viewModel.searchText.isEmpty {
                        await viewModel.loadMovies(reset: true)
                    } else {
                        await viewModel.filterMovies()
                    }
                }
            }
            Button(String(localized: "OK"), role: .cancel) {
                viewModel.clearError()
            }
        } message: {
            if let msg = viewModel.errorMessage {
                Text(msg)
            }
        }
        .favoriteErrorAlert(viewModel: favoriteViewModel)
    }

    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(viewModel.searchText.isEmpty ? String(localized: "No movies in theaters") : String(localized: "No results for \"\(viewModel.searchText)\""))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

// MARK: - Preview
struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

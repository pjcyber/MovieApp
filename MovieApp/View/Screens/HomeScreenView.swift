//
//  ContentView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

struct HomeScreenView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: MovieViewModel = MovieViewModel()
    @State private var selectedMovie: Movie?
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.movies.indices, id: \.self) { index in
                        let movie = viewModel.movies[index]
                        if movie.posterPath != nil {
                            MovieGridItemView(movie: movie)
                                .onAppear {
                                    if index == viewModel.movies.count - 1 {
                                        Task {
                                            await viewModel.loadMovies()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    selectedMovie = movie
                                }
                                .accessibilityIdentifier("movieGridItemView")
                        }
                    }
                }
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .navigationTitle("Now Playing")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        
                        NavigationLink(destination: FavoriteMoviesScreenView()) {
                            Label("Favorite Movies", systemImage: "heart")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
            .navigationDestination(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { newValue in
                Task {
                    if newValue.isEmpty {
                        await viewModel.loadMovies(reset: true)
                    } else {
                        await viewModel.filterMovies()
                    }
                }
            }
            
            .task {
                await viewModel.loadMovies()
            }
        }
        
    }
}


// MARK: - Preview
struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

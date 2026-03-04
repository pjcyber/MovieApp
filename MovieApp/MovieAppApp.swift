//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI
import SwiftData

@main
struct MovieAppApp: App {

    private let modelContainer: ModelContainer

    private static func makeInMemoryContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: FavoriteMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        } catch {
            fatalError("SwiftData in-memory container could not be created: \(error)")
        }
    }

    init() {
        let cache = URLCache(memoryCapacity: AppConfig.urlCacheMemoryCapacity, diskCapacity: AppConfig.urlCacheDiskCapacity)
        URLCache.shared = cache

        // Ensure Application Support exists so SwiftData store doesn't hit "parent directory missing"
        guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            modelContainer = Self.makeInMemoryContainer()
            return
        }
        let storeDir = appSupport.appendingPathComponent("MovieApp")
        try? FileManager.default.createDirectory(at: storeDir, withIntermediateDirectories: true)

        let storeURL = storeDir.appendingPathComponent("default.store")
        let config = ModelConfiguration(url: storeURL)
        do {
            modelContainer = try ModelContainer(for: FavoriteMovie.self, configurations: config)
        } catch {
            modelContainer = Self.makeInMemoryContainer()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.movieService, MovieService())
        }
        .modelContainer(modelContainer)
    }
}

private struct RootView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var favoriteViewModel = FavoriteMovieViewModel()
    @Environment(\.movieService) private var movieService

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeScreenView(movieService: movieService)
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(\.appRouter, router)
        .environment(\.favoriteMovieViewModel, favoriteViewModel)
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            EmptyView()
        case .favorites:
            FavoriteMoviesScreenView()
        case .movieDetail(let movie):
            MovieDetailView(movie: movie)
        }
    }
}

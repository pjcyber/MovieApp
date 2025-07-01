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
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
        }
        .modelContainer(for: FavoriteMovie.self)
    }
}

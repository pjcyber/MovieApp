//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 27/06/25.
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

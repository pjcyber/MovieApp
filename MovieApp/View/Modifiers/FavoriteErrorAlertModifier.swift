//
//  FavoriteErrorAlertModifier.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI

struct FavoriteErrorAlertModifier: ViewModifier {

    let viewModel: FavoriteMovieViewModel?

    private var isPresented: Bool {
        viewModel?.errorMessage != nil
    }

    func body(content: Content) -> some View {
        content
            .alert(String(localized: "Favorites"), isPresented: .constant(isPresented)) {
                Button(String(localized: "OK"), role: .cancel) {
                    viewModel?.clearError()
                }
            } message: {
                Text(viewModel?.errorMessage ?? "")
            }
    }
}

extension View {

    func favoriteErrorAlert(viewModel: FavoriteMovieViewModel?) -> some View {
        modifier(FavoriteErrorAlertModifier(viewModel: viewModel))
    }
}

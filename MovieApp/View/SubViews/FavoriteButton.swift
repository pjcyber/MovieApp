//
//  FavoriteButton.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI

struct FavoriteButton: View {

    let isFavorite: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: {
            withAnimation { onToggle() }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isFavorite ? .red : .white)
                .padding(8)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
        }
        .padding(10)
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? String(localized: "Remove from favorites") : String(localized: "Add to favorites"))
        .accessibilityHint(String(localized: "Double tap to toggle"))
    }
}

// MARK: - Preview
struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoriteButton(isFavorite: false, onToggle: {})
            FavoriteButton(isFavorite: true, onToggle: {})
        }
    }
}

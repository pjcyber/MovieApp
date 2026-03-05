//
//  AppRouter.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import SwiftUI

final class AppRouter: ObservableObject {

    @Published var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = []
    }
}

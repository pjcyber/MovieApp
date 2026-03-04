//
//  AppRoute.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation

enum AppRoute: Hashable {
    case home
    case favorites
    case movieDetail(Movie)
}

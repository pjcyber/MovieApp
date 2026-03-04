//
//  FavoriteMovie.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 19/07/25.
//

import Foundation
import SwiftData

@Model
class FavoriteMovie {
    var id: UUID
    var originalId: Int
    var overview: String
    var posterPath: String?
    var title: String
    var voteAverage: Double?
    var voteCount: Int?

    init(id: UUID = UUID(), originalId: Int, overview: String, posterPath: String?, title: String, voteAverage: Double?, voteCount: Int?) {
        self.id = id
        self.originalId = originalId
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

//
//  FavoriteMovie.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 30/06/25.
//

import Foundation
import SwiftData

@Model
class FavoriteMovie {
    var id: UUID
    var orgintalId: Int
    let overview: String
    let posterPath: String?
    var title: String
    var voteAverage: Double?
    var voteCount: Int?

    init(id: UUID = UUID(), orgintalId: Int, overview: String, posterPath: String?, title: String, voteAverage: Double?, voteCount: Int?) {
        self.id = id
        self.orgintalId = orgintalId
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

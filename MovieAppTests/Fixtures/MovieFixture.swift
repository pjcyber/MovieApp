//
//  MovieFixture.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

extension Movie {
    static var fixture: Movie {
        return Movie(id: 1,title: "test", overview: "overview", posterPath: "/d73UqZWyw3MUMpeaFcENgLZ2kWS.jpg", voteAverage: 7.557 , voteCount: 6566)
    }
}

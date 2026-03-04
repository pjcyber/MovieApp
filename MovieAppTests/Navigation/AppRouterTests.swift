//
//  AppRouterTests.swift
//  MovieAppTests
//
//  Created by Pedro Borrayo on 19/07/25.
//

import XCTest
@testable import MovieApp

final class AppRouterTests: XCTestCase {

    var router: AppRouter!

    override func setUp() {
        super.setUp()
        router = AppRouter()
    }

    func testPushAppendsRoute() {
        XCTAssertTrue(router.path.isEmpty)

        router.push(.favorites)
        XCTAssertEqual(router.path.count, 1)
        if case .favorites = router.path[0] { } else {
            XCTFail("Expected .favorites")
        }

        let movie = Movie(id: 1, title: "Test", overview: "O", posterPath: nil, voteAverage: nil, voteCount: nil)
        router.push(.movieDetail(movie))
        XCTAssertEqual(router.path.count, 2)
        if case .movieDetail(let m) = router.path[1] {
            XCTAssertEqual(m.id, 1)
        } else {
            XCTFail("Expected .movieDetail")
        }
    }

    func testPopRemovesLast() {
        router.push(.favorites)
        router.push(.home)
        XCTAssertEqual(router.path.count, 2)

        router.pop()
        XCTAssertEqual(router.path.count, 1)
        if case .favorites = router.path[0] { } else { XCTFail("Expected .favorites") }

        router.pop()
        XCTAssertTrue(router.path.isEmpty)
    }

    func testPopWhenEmptyDoesNothing() {
        router.pop()
        XCTAssertTrue(router.path.isEmpty)
    }

    func testPopToRootClearsPath() {
        router.push(.favorites)
        let movie = Movie(id: 1, title: "T", overview: "O", posterPath: nil, voteAverage: nil, voteCount: nil)
        router.push(.movieDetail(movie))
        XCTAssertEqual(router.path.count, 2)

        router.popToRoot()
        XCTAssertTrue(router.path.isEmpty)
    }

    func testNavigationFlowHomeToDetailToBack() {
        let movie = Movie(id: 42, title: "Flow", overview: "Overview", posterPath: "/p.jpg", voteAverage: 8.0, voteCount: 100)
        router.push(.movieDetail(movie))
        XCTAssertEqual(router.path.count, 1)
        if case .movieDetail(let m) = router.path[0] {
            XCTAssertEqual(m.id, 42)
        } else {
            XCTFail("Expected .movieDetail")
        }
        router.pop()
        XCTAssertTrue(router.path.isEmpty)
    }
}

//
//  HomeScreenViewUITests.swift
//  MovieAppUITests
//
//  Created by Pedro Borrayo on 30/06/25.
//

import XCTest

final class HomeScreenViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testHomeScreenViewLoadsAndDisplaysTitle() {
        let navTitle = app.navigationBars["Now Playing"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5), "Navigation title 'Now Playing' should exist")
    }

    func testGridLoadsMovies() {
        // Wait for cells to appear (assuming movies load automatically)
        let movieCells = app.scrollViews.descendants(matching: .any).matching(identifier: "movieGridItemView")

        // Give time for data to load
        let exists = movieCells.firstMatch.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Expected at least one movie grid item to appear")
    }

    func testTappingMovieNavigatesToDetail() {
        let movieCells = app.scrollViews.descendants(matching: .any).matching(identifier: "movieGridItemView")
        
        guard movieCells.count > 0 else {
            XCTFail("No movie cells available for tapping")
            return
        }
        
        movieCells.element(boundBy: 0).tap()

        let detailHeader = app.staticTexts["movieDetailTitle"]
        XCTAssertTrue(detailHeader.waitForExistence(timeout: 5), "Expected navigation to movie detail view")
    }

    func testSearchFiltersMovies() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)

        searchField.tap()
        searchField.typeText("batman\n") // Simulate search

        // Wait and verify filtered content
        let movieCells = app.scrollViews.descendants(matching: .any).matching(identifier: "movieGridItemView")
        XCTAssertTrue(movieCells.firstMatch.waitForExistence(timeout: 5))
    }
}


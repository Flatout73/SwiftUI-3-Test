//
//  MooncascadeUITests.swift
//  MooncascadeUITests
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import XCTest

class MooncascadeUITests: XCTestCase {

    override func setUpWithError() throws {
       // try! FileManager.default.removeItem(at: Bundle.main.url(forResource: "Mooncascade", withExtension: "sqlite")!)
        
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPosition() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.tables.children(matching: .cell).firstMatch.tap()

        let position = app.staticTexts["Position"]
        XCTAssertTrue(position.waitForExistence(timeout: 5))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

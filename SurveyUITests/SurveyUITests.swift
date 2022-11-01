//
//  SurveyUITests.swift
//  SurveyUITests
//
//  Created by argyro gounari on 29/10/2022.
//

import XCTest

class SurveyUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
        
        let startSurveyButton = app.buttons["startSurveyButton"]
        startSurveyButton.tap()
    }

    func testAllRequiredControlsArePresentOnStartSurvey() throws {
        XCTAssert(app.buttons["previousToolBarButton"].exists)
        XCTAssertFalse(app.buttons["previousToolBarButton"].isEnabled)
        XCTAssert(app.buttons["nextToolBarButton"].exists)
        XCTAssert(app.buttons["nextToolBarButton"].isEnabled)
        sleep(10)
        XCTAssert(app.staticTexts["questionsSubmittedText"].exists)
        XCTAssert(app.staticTexts["questionText"].exists)
        XCTAssert(app.textFields["answerTextField"].exists)
        XCTAssert(app.buttons["submitButton"].exists)
        XCTAssertFalse(app.buttons["submitButton"].isEnabled)
    }
    
    func testSubmitButtonShowsNotification() {
        let aswerTextField = app.textFields["answerTextField"]
        aswerTextField.tap()
        aswerTextField.typeText("My answer to the question")
        app.buttons["submitButton"].tap()
        sleep(2)
        XCTAssert(app.buttons["notificationBanner"].exists)
    }
}

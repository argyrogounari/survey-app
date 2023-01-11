//
//  TabViewWithQuestionsTest.swift
//  SurveyTests
//
//  Created by Argyro Gounari on 10/01/2023.
//

import ComposableArchitecture
import Foundation
@testable import Survey
import XCTest

class TabViewWithQuestionsTest: XCTestCase {
    func testNavigationToSurveyAfterButtonTapped() {
        let store = TestStore(
            initialState: WelcomeState(),
            reducer: welcomeReducer,
            environment: WelcomeEnvironment()
        )
        
        store.send(.welcomeTapped) {
            $0.isShowingDetailView = true
        }
    }
}

//
//  DatabaseTests.swift
//  SurveyTests
//
//  Created by argyro gounari on 01/11/2022.
//

import ComposableArchitecture
import Foundation
import Combine
@testable import Survey
import XCTest

class DatabaseTests: XCTestCase {

    func testSetAnswer() {
        let scheduler = DispatchQueue.test
        let question = Question(id: 1, question: "What is your favourite color?", answer: "Blue")
        
        let store = TestStore(initialState: QuestionState(question: question), reducer: questionReducer, environment: QuestionEnvironment(mainQueue: scheduler.eraseToAnyScheduler(), setAnswerAPICall: { _ in Effect<Int, APIError>(value: 200)
        }, numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0)))
       
       store.send(.submitButtonClicked)
       store.receive(.submitAnswer)
       store.receive(.submitAnswerResponse(.success(200))) {
            $0.submitButtonState = SubmitButtonState.disableQuestionSubmitted
            $0.answerTextFieldState = AnswerTextFieldState.disabled
            $0.showSuccessNotificationBanner = true
        }
        store.receive(.numQuestionsSubmittedIncreased)
    }
}


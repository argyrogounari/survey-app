//
//  QuestionTests.swift
//  QuestionTests
//
//  Created by argyro gounari on 01/11/2022.
//

import ComposableArchitecture
import Foundation
import Combine
@testable import Survey
import XCTest

class QuestionTests: XCTestCase {

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
    
    func testRetryButtonFromNotificationPressed() {
        let scheduler = DispatchQueue.test
        let question = Question(id: 1, question: "What is your favourite color?", answer: "Blue")
        
        let store = TestStore(initialState: QuestionState(question: question), reducer: questionReducer, environment: QuestionEnvironment(mainQueue: scheduler.eraseToAnyScheduler(), setAnswerAPICall: { _ in Effect<Int, APIError>(value: 200)
        }, numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0)))
       
       store.send(.notificationBannerRetryPressed)
       store.receive(.submitButtonClicked)
       store.receive(.submitAnswer)
       store.receive(.submitAnswerResponse(.success(200))) {
            $0.submitButtonState = SubmitButtonState.disableQuestionSubmitted
            $0.answerTextFieldState = AnswerTextFieldState.disabled
            $0.showSuccessNotificationBanner = true
        }
        store.receive(.numQuestionsSubmittedIncreased)
    }
    
    func testNumOfQuestionsSubmittedIncreased() {
        let scheduler = DispatchQueue.test
        let store = TestStore(initialState: AppState(tabView: TabViewState(questions: [QuestionState(question: Question(id: 1, question: "What is your favourite color?")), QuestionState(question: Question(id: 2, question: "What is your favourite animal?"))]), totalQusetionsSubmitted: TotalQusetionsSubmittedState()), reducer: appReducer, environment: AppEnvironment(mainQueue: scheduler.eraseToAnyScheduler(), numQuestionsSubmitted:  CurrentValueSubject<Int, Never>(0)))
        
        store.send(.tabView(.question(id: 1, action: .numQuestionsSubmittedIncreased)))
        store.send(.totalQusetionsSubmitted(.valueChanged(1))) {
            $0.totalQusetionsSubmitted.num = 1
        }
    }
}


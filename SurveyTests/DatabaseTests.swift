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
    var urlSession: URLSession!
    let scheduler = DispatchQueue.test
    let mockQuestions = [Question(id: 1, question: "What is your favourite color?"), Question(id: 2, question: "What is your favourite animal?")]
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    func setAnswerAPICallMock() -> Effect<Int, APIError> {
        return Effect<Int, APIError>(value: 200)
    }
    
    func testGetQuestions() {
        let store = TestStore(
            initialState: TabViewState(),
            reducer: tabViewReducer,
            environment: TabViewEnvironment(mainQueue: scheduler.eraseToAnyScheduler(),
                                            getQuestionsAPICall: { Effect<[Question], APIError>(value: self.mockQuestions
                                            ) }, numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0))
        )
        
        store.send(.fetchQuestionsAPICall)
        scheduler.advance()
        store.receive(.fetchQuestionsResponse(.success(mockQuestions))) {
            $0.questions = [QuestionState(question: Question(id: 1, question: "What is your favourite color?")), QuestionState(question: Question(id: 2, question: "What is your favourite animal?"))]
        }
    }
    
    func testSetAnswer() {
        let question = Question(id: 1, question: "What is your favourite color?", answer: "Blue")
        
        let store = TestStore(initialState: QuestionState(question: question), reducer: questionReducer, environment: QuestionEnvironment(mainQueue: scheduler.eraseToAnyScheduler(), setAnswerAPICall: { _ in self.setAnswerAPICallMock()
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


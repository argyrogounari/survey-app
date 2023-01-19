//
//  TabViewWithQuestionsTest.swift
//  SurveyTests
//
//  Created by Argyro Gounari on 10/01/2023.
//

import ComposableArchitecture
import Foundation
import Combine
@testable import Survey
import XCTest

class TabViewWithQuestionsTest: XCTestCase {
    
    func testGetQuestions() {
        let scheduler = DispatchQueue.test
        let mockQuestions = [Question(id: 1, question: "What is your favourite color?"), Question(id: 2, question: "What is your favourite animal?")]
        let store = TestStore(
            initialState: TabViewState(),
            reducer: tabViewReducer,
            environment: TabViewEnvironment(mainQueue: scheduler.eraseToAnyScheduler(),
                                            getQuestionsAPICall: { Effect<[Question], APIError>(value: mockQuestions
                                            ) }, numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0))
        )
        
        store.send(.onAppear)
        store.receive(.fetchQuestionsAPICall)
        scheduler.advance()
        store.receive(.fetchQuestionsResponse(.success(mockQuestions))) {
            $0.questions = [QuestionState(question: Question(id: 1, question: "What is your favourite color?")), QuestionState(question: Question(id: 2, question: "What is your favourite animal?"))]
        }
    }
    
    func testButtonsEnabledBasedOnFirstLastQuestion() {
        let store = TestStore(
            initialState: TabViewState(questions: [QuestionState(question: Question(id: 1, question: "What is your favourite color?")), QuestionState(question: Question(id: 2, question: "What is your favourite animal?"))]),
            reducer: tabViewReducer,
            environment: TabViewEnvironment(
                mainQueue: DispatchQueue.test.eraseToAnyScheduler(),
                getQuestionsAPICall: {
                    Effect<[Question], APIError>(value: [Question(id: 1, question: "What is your favourite color?"), Question(id: 2, question: "What is your favourite animal?")])
                },
                numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0))
        )
        
        // When on the last question, next button should be disabled
        store.send(.nextTapped)
        store.receive(.questionOnDisplayChanged(currentQuestionTag: 2)) {
            $0.currentQuestionTag = 2
            $0.isPreviousButtonDisabled = false
            $0.isNextButtonDisabled = true
        }

        // When on the first question, previous button should be disabled
        store.send(.previousTapped)
        store.receive(.questionOnDisplayChanged(currentQuestionTag: 1)) {
            $0.currentQuestionTag = 1
            $0.isPreviousButtonDisabled = true
            $0.isNextButtonDisabled = false
        }
    }
}

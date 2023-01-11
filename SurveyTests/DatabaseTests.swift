//
//  DatabaseTests.swift
//  SurveyTests
//
//  Created by argyro gounari on 01/11/2022.
//

import ComposableArchitecture
import Foundation
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
    
    func testGetQuestions() {
        let store = TestStore(
            initialState: TabViewState(),
            reducer: tabViewReducer,
            environment: TabViewEnvironment(mainQueue: scheduler.eraseToAnyScheduler(),
                                            getQuestionsAPICall: { Effect<[Question], APIError>(value: self.mockQuestions
                                            ) })
        )
        
        store.send(.fetchQuestionsAPICall)
        scheduler.advance()
        store.receive(.fetchQuestionsResponse(.success(mockQuestions))) {
            $0.questions = [QuestionState(question: Question(id: 1, question: "What is your favourite color?")), QuestionState(question: Question(id: 2, question: "What is your favourite animal?"))]
        }
    }
    
    func testSetAnswer() async throws {
        //        let database = await Database(urlSession: urlSession)
        //
        //        let question = Question(id: 1, question: "What is your favourite color?", answer: "Blue")
        //        let mockData = try JSONEncoder().encode(question)
        //
        //        MockURLProtocol.requestHandler = { request in
        //            return (HTTPURLResponse(), mockData)
        //        }
        //
        //        let expectation = XCTestExpectation(description: "Post Answer")
        //
        //        await database.setAnswer(question: question) { httpResponse, isSuccessful in
        //            XCTAssertEqual(httpResponse.statusCode == 200 || httpResponse.statusCode == 400, true)
        //            if (httpResponse.statusCode == 200) {
        //                XCTAssertEqual(isSuccessful, true)
        //            } else if (httpResponse.statusCode == 400) {
        //                XCTAssertEqual(isSuccessful, false)
        //            }
        //            expectation.fulfill()
        //        }
        //
        //        self.wait(for: [expectation], timeout: 1)
    }
}




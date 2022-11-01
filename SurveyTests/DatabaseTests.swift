//
//  DatabaseTests.swift
//  SurveyTests
//
//  Created by argyro gounari on 01/11/2022.
//

import XCTest
@testable import Survey

class DatabaseTests: XCTestCase {
    var urlSession: URLSession!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    func testGetQuestions() async throws {
        let database = await Database(urlSession: urlSession)
        
        let mockQuestions = [Question(id: 1, question: "What is your favourite color?"), Question(id: 2, question: "What is your favourite animal?")]
        let mockData = try JSONEncoder().encode(mockQuestions)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "Get Questions")
        
        await database.getQuestions{ questions in
            XCTAssertEqual(questions[0].id, 1)
            XCTAssertEqual(questions[0].question, "What is your favourite color?")
            XCTAssertEqual(questions[1].id, 2)
            XCTAssertEqual(questions[1].question, "What is your favourite animal?")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testSetAnswer() async throws {
        let database = await Database(urlSession: urlSession)
        
        let question = Question(id: 1, question: "What is your favourite color?", answer: "Blue")
        let mockData = try JSONEncoder().encode(question)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "Post Answer")
        
        await database.setAnswer(question: question) { httpResponse, isSuccessful in
            XCTAssertEqual(httpResponse.statusCode == 200 || httpResponse.statusCode == 400, true)
            if (httpResponse.statusCode == 200) {
                XCTAssertEqual(isSuccessful, true)
            } else if (httpResponse.statusCode == 400) {
                XCTAssertEqual(isSuccessful, false)
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
}

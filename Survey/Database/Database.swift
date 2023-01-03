//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation
import Combine

enum APIError: Error {
    case runtimeError(String)
}

@MainActor public class Database: ObservableObject {
    let session: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    public func getQuestions() async throws -> [Question] {
        let fetchTask = Task { () -> [Question] in
            guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
                throw APIError.runtimeError("Invalid URL: https://xm-assignment.web.app/questions")
            }
            let (data, _) = try await self.session.data(from: url)
            let questions = try? JSONDecoder().decode([Question].self, from: data)
            return questions!
        }
        
        let result = await fetchTask.result
        
        switch result {
            case .success(let questions):
                return questions
            case .failure(let error):
                throw error
        }
    }
    
    public func setAnswer(question: Question)  async throws -> HTTPURLResponse {
        let setTask = Task { () -> HTTPURLResponse in
            guard let url = URL(string: "https://xm-assignment.web.app/question/submit") else {
                throw APIError.runtimeError("Invalid URL: https://xm-assignment.web.app/question/submit")
            }
            guard let encoded = try? JSONEncoder().encode(question) else {
                throw APIError.runtimeError("Failed to encode question.")
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let (_, response) = try await session.upload(for: request, from: encoded)
            if let httpResponse = response as? HTTPURLResponse {
//                if (httpResponse.statusCode == 200) {
//                    completion(httpResponse, true)
//                    return
//                }
//                completion(httpResponse, false)
                
                return httpResponse
            }
            
            throw APIError.runtimeError("Could not set answer.")
        }
        
        let result = await setTask.result
        
        switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
        }
    }
}


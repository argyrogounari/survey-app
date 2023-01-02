//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation
import Combine

@MainActor public class Database: ObservableObject {
    let session: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    public func getQuestions() async throws -> [Question] {
        let fetchTask = Task { () -> [Question] in
            guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
                print("Invalid URL: https://xm-assignment.web.app/questions")
                return []
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
    
    public func setAnswer(question: Question, completion: (HTTPURLResponse, Bool) -> Void) async {
        guard let url = URL(string: "https://xm-assignment.web.app/question/submit") else {
            print("Invalid URL: https://xm-assignment.web.app/question/submit")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(question) else {
            print("Failed to encode question.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (_, response) = try await session.upload(for: request, from: encoded)
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    completion(httpResponse, true)
                    return
                }
                completion(httpResponse, false)
                return
            }
        } catch {
            print("Failed to submit answer: \(error)")
        }
    }
}


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
    
    public func getQuestions(completion: @escaping ([Question]) -> Void) async {
        guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
            print("Invalid URL: https://xm-assignment.web.app/questions")
            return
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            
            if let questions = try? JSONDecoder().decode([Question].self, from: data) {
                completion(questions)
            }
        } catch {
            print("Failed to get questions: \(error)")
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

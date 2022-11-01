//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation
import Combine

class Database: ObservableObject {
    let session: URLSession

    init(urlSession: URLSession = .shared) {
       self.session = urlSession
    }
    
    func getQuestions(completion: @escaping ([Question]) -> Void) async {
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
            print("Invalid data: \(error)")
        }
    }
    
    func setAnswer(question: Question) async -> Bool {
        guard let url = URL(string: "https://xm-assignment.web.app/question/submit") else {
            print("Invalid URL: https://xm-assignment.web.app/question/submit")
            return false
        }
        
        guard let encoded = try? JSONEncoder().encode(question) else {
            print("Failed to encode question")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (_, response) = try await session.upload(for: request, from: encoded)
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    return true
                }
            }
            return false
        } catch {
            print("Sumbitting answer failed: \(error)")
        }
        
        return false
    }
}

//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation
import Combine

class Database: ObservableObject {
    @Published var questions: [Question] = []
    
    func getQuestions() {
        guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
            print("Invalid URL: https://xm-assignment.web.app/questions")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error  in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let questions = try JSONDecoder().decode([Question].self, from: data)
                DispatchQueue.main.async {
                    self?.questions = questions
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
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
            let (_, response) = try await URLSession.shared.upload(for: request, from: encoded)
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

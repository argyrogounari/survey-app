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
    
    func setQuestions() {
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
}

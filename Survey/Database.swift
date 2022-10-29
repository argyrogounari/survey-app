//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation

class Database {
    
    func getQuestions() async -> [Question]  {
        guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
            print("Invalid URL: https://xm-assignment.web.app/questions")
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let questions = try? JSONDecoder().decode([Question].self, from: data) {
                return questions
            }
        } catch {
            print("Invalid data: \(error)")
        }
        
        return []
    }
}

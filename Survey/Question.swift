//
//  Question.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation

struct Questions: Codable {
    var questions: [Question]
}

class Question: ObservableObject, Codable {
    let id: Int
    let question: String
    @Published var answer: String = ""
    @Published var isSubmitted: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case question
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
    }
}

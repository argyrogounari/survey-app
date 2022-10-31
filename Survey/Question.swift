//
//  Question.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation

class Question: ObservableObject, Codable, Identifiable {
    let id: Int
    let question: String
    @Published var answer: String = ""
    @Published var isSubmitted: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case question
        case answer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(answer, forKey: .answer)
    }
    
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

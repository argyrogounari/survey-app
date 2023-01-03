//
//  Question.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation

public class Question: ObservableObject, Codable, Identifiable, Equatable {
    public let id: Int
    public let question: String
    @Published public var answer: String = ""
    
    enum CodingKeys: CodingKey {
        case id
        case question
        case answer
    }
    
    public init() {
        id = 0
        question = ""
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(question, forKey: .question)
        try container.encodeIfPresent(answer, forKey: .answer)
    }
    
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
    
    init(id: Int, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    public static func == (_ lhs: Question, _ rhs: Question) -> Bool {
        if (lhs.id == rhs.id &&
            lhs.question == rhs.question &&
            lhs.answer == rhs.answer) {
            return true
        }
        return false
    }
}

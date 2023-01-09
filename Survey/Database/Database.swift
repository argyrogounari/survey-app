//
//  Database.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Foundation
import Combine
import ComposableArchitecture

enum APIError: Error, Equatable {
    case runtimeError(String)
}

public class Database: ObservableObject {
    let session: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func getQuestions() -> Effect<[Question], APIError>  {
        Effect.run { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }
            
            guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
                subscriber.send(completion: .failure(APIError.runtimeError("Invalid URL: https://xm-assignment.web.app/questions")))
                return AnyCancellable {}
            }
            let dataTask = self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    subscriber.send(completion: .failure(APIError.runtimeError(error.localizedDescription)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    subscriber.send(completion: .failure(APIError.runtimeError("Fetch of questions from URL failed.")))
                    return
                }
                if let data = data {
                    guard let questions = try? JSONDecoder().decode([Question].self, from: data) else {
                        subscriber.send(completion: .failure(APIError.runtimeError("Could not decode data to questions.")))
                        return
                    }
                    subscriber.send(questions)
                    subscriber.send(completion: .finished)
                }
            }
            dataTask.resume()
            
            return AnyCancellable {
                dataTask.cancel()
            }
        }
    }
    
    //        return response.map({ _ , response -> Effect<Data, APIError> in
    //            if let httpResponse = response as? HTTPURLResponse {
    //                return Effect(value: httpResponse)
    //            }
    //            return Effect(error: APIError.runtimeError("Could not set answer."))
    //        }).eraseToEffect()
    //        guard let questions = try? JSONDecoder().decode([Question].self, from: data) else {
    //            return Effect(error: APIError.runtimeError("Failed to decode questions."))
    //        }
    
    
    //        let fetchTask = Task { () -> [Question] in
    //            guard let url = URL(string: "https://xm-assignment.web.app/questions") else {
    //                throw APIError.runtimeError("Invalid URL: https://xm-assignment.web.app/questions")
    //            }
    //            let (data, _) = try await self.session.data(from: url)
    //            let questions = try? JSONDecoder().decode([Question].self, from: data)
    //            return questions!
    //        }
    //
    //        let result = await fetchTask.result
    //
    //        switch result {
    //        case .success(let questions):
    //            return questions
    //        case .failure(let error):
    //            throw error
    //        }
    
    func setAnswer(question: Question)  -> Effect<HTTPURLResponse, APIError> {
        guard let url = URL(string: "https://xm-assignment.web.app/question/submit") else {
            return Effect(error: APIError.runtimeError("Invalid URL: https://xm-assignment.web.app/question/submit"))
            
        }
        guard let encoded = try? JSONEncoder().encode(question) else {
            return Effect(error: APIError.runtimeError("Failed to encode question."))
        }
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        let response = session.dataTaskPublisher(for: request).mapError({_ in
            APIError.runtimeError("URL session failed.")
        })
        return response.flatMap({ _ , response -> Effect<HTTPURLResponse, APIError> in
            if let httpResponse = response as? HTTPURLResponse {
                return Effect(value: httpResponse)
            }
            return Effect(error: APIError.runtimeError("Could not set answer."))
        }).eraseToEffect()
    }
}


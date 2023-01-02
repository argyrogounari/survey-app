//
//  TabViewReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 28/12/2022.
//

import Foundation
import ComposableArchitecture

public struct TabViewReducer: ReducerProtocol {
    let questionsList: () async throws -> [Question]
    
    public struct State: Equatable {
        var numQuestionsSubmitted = 0
        var currentQuestion = 1
        var isPreviousButtonDisabled = true
        var isNextButtonDisabled = false
        var questions: [Question] = []
    }

    public enum Action: Equatable  {
        case previousTapped
        case nextTapped
        case questionOnDisplayChanged // is this action? maybe effect?
        case onAppear
        case fetchQuestionsAPICall
        case getQuestionsListResponse(TaskResult<[Question]>)
        case questionSelectionChanged
        case questionModified(question: Question, position: Int)
        case numQuestionsSubmittedChanged(numQuestionsSubmitted: Int)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .previousTapped:
            state.currentQuestion -= 1
            return .none
        case .nextTapped:
            state.currentQuestion += 1
            return .none
        case .questionOnDisplayChanged:
            state.isPreviousButtonDisabled = state.currentQuestion == 1
            state.isNextButtonDisabled = state.currentQuestion == state.questions.last?.id
            return .none
        case .questionSelectionChanged:
            return .none
        case .onAppear:
            return Effect(value: .fetchQuestionsAPICall)
        case .fetchQuestionsAPICall:
            return .task {
                await .getQuestionsListResponse(
                    TaskResult {
                        try await self.questionsList()
                  })
              }
        case let .getQuestionsListResponse(.success(questionsList)):
            state.questions = questionsList
            return .none
        case .getQuestionsListResponse(.failure):
            return .none
        case .questionModified(question: let question, position: let position):
            state.questions[position] = question
            return .none
        case .numQuestionsSubmittedChanged(numQuestionsSubmitted: let numQuestionsSubmitted):
            state.numQuestionsSubmitted = numQuestionsSubmitted
            return .none
        }
    }
}







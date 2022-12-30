//
//  QuestionsViewer.swift
//  QuestionsViewer
//
//  Created by Argyro Gounari on 28/12/2022.
//

import Foundation
import ComposableArchitecture

public struct QuestionsViewer: ReducerProtocol {
    public struct State: Equatable {
        var numQuestionsSubmitted = 0
        var currentQuestion = 1
        var isPreviousButtonDisabled = true
        var isNextButtonDisabled = false
        var questions: [Question] = []
    }
    
    
    struct Sdtate: Equatable {
        var count = 0
        var numberFactAlert: String?
      }

    
    public enum Action: Equatable  {
        case previousTapped
        case nextTapped
        case questionOnDisplayChanged // is this action? maybe effect?
        case tabViewAppeared
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
        case .tabViewAppeared:
            Task {
                await Database().getQuestions{ questionsList in
    //                state.questions = questionsList
                }
            }
            return .none
        }
    }
}







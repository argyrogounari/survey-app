//
//  TabViewReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 28/12/2022.
//

import Combine
import Foundation
import SwiftUI
import ComposableArchitecture

public struct TabViewState: Equatable {
    var currentQuestionTag = 1
    var isPreviousButtonDisabled = true
    var isNextButtonDisabled = false
    var questions: IdentifiedArrayOf<QuestionState> = []
}

enum TabViewAction: Equatable  {
    case previousTapped
    case nextTapped
    case questionOnDisplayChanged(currentQuestionTag: Int)
    case onAppear
    case fetchQuestionsAPICall
    case fetchQuestionsResponse(Result<[Question], APIError>)
    case question(id: QuestionState.ID, action: QuestionAction)
}

struct TabViewEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let getQuestionsAPICall: () -> Effect<[Question], APIError>
    let numQuestionsSubmitted: CurrentValueSubject<Int, Never>
}

let tabViewReducer = Reducer<TabViewState, TabViewAction, TabViewEnvironment>.combine(
    questionReducer.forEach(
        state: \TabViewState.questions,
        action: /TabViewAction.question(id:action:),
        environment: { env in QuestionEnvironment(
            mainQueue: env.mainQueue,
            setAnswerAPICall: Database().setAnswer,
            numQuestionsSubmitted: env.numQuestionsSubmitted
        )}
    ),
    Reducer { state, action, environment in
        switch action {
        case .previousTapped:
            return Effect(value: .questionOnDisplayChanged(currentQuestionTag: state.currentQuestionTag - 1))
        case .nextTapped:
            return Effect(value: .questionOnDisplayChanged(currentQuestionTag: state.currentQuestionTag + 1))
        case let .questionOnDisplayChanged(currentQuestionTag):
            state.currentQuestionTag = currentQuestionTag
            if (currentQuestionTag == state.questions.first?.question.id) {
                state.isPreviousButtonDisabled = true
                state.isNextButtonDisabled = false
            } else if (currentQuestionTag == state.questions.last?.question.id) {
                state.isPreviousButtonDisabled = false
                state.isNextButtonDisabled = true
            } else {
                state.isPreviousButtonDisabled = false
                state.isNextButtonDisabled = false
            }
            return .none
        case .onAppear:
            return Effect(value: .fetchQuestionsAPICall)
        case .fetchQuestionsAPICall:
            return environment.getQuestionsAPICall()
                .receive(on: environment.mainQueue)
                .catchToEffect().map(TabViewAction.fetchQuestionsResponse)
        case let .fetchQuestionsResponse(.success(questionsList)):
            questionsList.forEach({ question in
                state.questions.append(QuestionState(question: question))
            })
            return .none
        case .fetchQuestionsResponse(.failure):
            return .none
        case .question(id: let id, action: let action):
            return .none
        }
    }
)

//
//  TabViewReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 28/12/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct TabViewState: Equatable {
    var currentQuestionTag = 1
    var isPreviousButtonDisabled = true
    var isNextButtonDisabled = false
    var questions: IdentifiedArrayOf<QuestionState> = []
}

public struct QuestionState: Equatable, Identifiable {
    public var id: Int {
        question.id
    }
    var numQuestionsSubmitted = 0
    var question: Question
    var submitButtonState: SubmitButtonState = .disableQuestionNotSubmitted
    var answerTextFieldState: AnswerTextFieldState = .enabled
    var showFailNotificationBanner: Bool = false
    var showSuccessNotificationBanner: Bool = false
    
    public init (question: Question) {
        self.question = question
    }
}

enum TabViewAction: Equatable  {
    case previousTapped
    case nextTapped
    case questionOnDisplayChanged(currentQuestionTag: Int)
    case onAppear
    case fetchQuestionsAPICall
    case fetchQuestionsResponse(Result<[Question], APIError>)
    case questionSelectionChanged
    case questionModified(question: Question, position: Int)
    case question(id: QuestionState.ID, action: QuestionAction)
}

enum QuestionAction: Equatable  {
    case submitButtonClicked
    case submitAnswer
    case submitAnswerResponse(Result<HTTPURLResponse, APIError>)
    case setSubmitButtonAppearance(answer: String)
    case numQuestionsSubmittedChanged(numQuestionsSubmitted: Int)
    case notificationBannerDismissed
}

struct QuestionEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let setAnswerAPICall: (Question) -> Effect<HTTPURLResponse, APIError>
}

struct TabViewEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let getQuestionsAPICall: () -> Effect<[Question], APIError>
}

let questionReducer = Reducer<QuestionState, QuestionAction, QuestionEnvironment> { state, action, environment in
    switch action {
    case .setSubmitButtonAppearance(answer: let answer):
        if (answer.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            state.submitButtonState = .disableQuestionNotSubmitted
            return .none
        } else {
            state.submitButtonState = .enabled
            return .none
        }
    case .notificationBannerDismissed:
        state.showSuccessNotificationBanner = false
        state.showFailNotificationBanner = false
        return .none
    case .submitButtonClicked:
        return Effect(value: .submitAnswer)
    case .submitAnswer:
        return environment.setAnswerAPICall(state.question).catchToEffect().map(QuestionAction.submitAnswerResponse)
    case let .submitAnswerResponse(.success(httpUrlResponse)):
        if (httpUrlResponse.statusCode == 200) {
            state.showFailNotificationBanner = false
            state.showSuccessNotificationBanner = true
            state.numQuestionsSubmitted += 1
            state.submitButtonState = .disableQuestionSubmitted
            state.answerTextFieldState = .disabled
            return .none
        } else {
            return Effect(value: .submitAnswerResponse(Result.failure(APIError.runtimeError("Failed to set answer"))))
        }
    case .submitAnswerResponse(.failure):
        state.showSuccessNotificationBanner = false
        state.showFailNotificationBanner = true
        return .none
    case .numQuestionsSubmittedChanged(numQuestionsSubmitted: let numQuestionsSubmitted):
        state.numQuestionsSubmitted = numQuestionsSubmitted
        return .none
    }
}
    .debug()

let tabViewReducer = Reducer<TabViewState, TabViewAction, TabViewEnvironment>.combine(
    questionReducer.forEach(
        state: \TabViewState.questions,
        action: /TabViewAction.question(id:action:),
        environment: { _ in QuestionEnvironment(
            mainQueue: .main,
            setAnswerAPICall: Database().setAnswer
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
        case .questionSelectionChanged:
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
        case .questionModified(question: let question, position: let position):
//            state.questions[position] = question
            return .none
        case .question(id: let id, action: let action):
            return .none
        }
    }
)
    .debug()


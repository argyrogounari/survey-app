//
//  QuestionState.swift
//  Survey
//
//  Created by Argyro Gounari on 20/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture

public struct QuestionState: Equatable, Identifiable {
    public var id: Int {
        question.id
    }
    var question: Question
    var submitButtonState: SubmitButtonState = .disableQuestionNotSubmitted
    var answerTextFieldState: AnswerTextFieldState = .enabled
    var showFailNotificationBanner: Bool = false
    var showSuccessNotificationBanner: Bool = false
    var retryFromNotificationBanner: Bool = false
}

enum QuestionAction: Equatable  {
    case submitButtonClicked
    case submitAnswer
    case submitAnswerResponse(Result<Int, APIError>)
    case setSubmitButtonAppearance(answer: String)
    case numQuestionsSubmittedIncreased
    case notificationBannerDismissed
    case notificationBannerRetryPressed
}

struct QuestionEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let setAnswerAPICall: (Question) -> Effect<Int, APIError>
    var numQuestionsSubmitted: CurrentValueSubject<Int, Never>
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
    case .submitButtonClicked:
        return Effect(value: .submitAnswer)
    case .submitAnswer:
        return environment.setAnswerAPICall(state.question).catchToEffect().map(QuestionAction.submitAnswerResponse)
    case let .submitAnswerResponse(.success(statusCode)):
        if (statusCode == 200) {
            state.showFailNotificationBanner = false
            state.showSuccessNotificationBanner = true
            state.submitButtonState = .disableQuestionSubmitted
            state.answerTextFieldState = .disabled
            return Effect(value: .numQuestionsSubmittedIncreased)
        } else {
            return Effect(value: .submitAnswerResponse(Result.failure(APIError.runtimeError("Failed to set answer"))))
        }
    case .submitAnswerResponse(.failure):
        state.showSuccessNotificationBanner = false
        state.showFailNotificationBanner = true
        return .none
    case .numQuestionsSubmittedIncreased:
        environment.numQuestionsSubmitted.value = environment.numQuestionsSubmitted.value + 1
        return .none
    case .notificationBannerDismissed:
        state.showSuccessNotificationBanner = false
        state.showFailNotificationBanner = false
        return .none
    case .notificationBannerRetryPressed:
        return Effect(value: .submitButtonClicked)
    }
}

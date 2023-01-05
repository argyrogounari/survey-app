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
    
    // submitbutton
    var submitButtonText = "Submit"
    var submitButtonForegroundColor = Color.gray
    var submitButtonBackgroundColor = Color.gray.opacity(0.2)
    var submitButtonDisabled = true
    var answerTextFieldColor = Color.black
    var answerTextFieldDisabled = false
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
    case getQuestionsListResponse(TaskResult<IdentifiedArrayOf<Question>>)
    case questionSelectionChanged
    case questionModified(question: Question, position: Int)
    case question(id: QuestionState.ID, action: QuestionAction)
}

enum QuestionAction: Equatable  {
    case submitButtonClicked(question: Question)
    case submitAnswer(question: Question)
    case submitAnswerResponse(Result<HTTPURLResponse, APIError>)
    case setSubmitButtonAppearance(answer: String)
    case setSumbitButtonDisabled
    case setSubmitButtonEnabled
    
    case numQuestionsSubmittedChanged(numQuestionsSubmitted: Int)
    
    case notificationBannerDismissed
}

struct QuestionEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let setAnswerAPICall: (Question) -> Effect<HTTPURLResponse, APIError>
}

struct TabViewEnvironment {
    let questionsList: () async throws -> [Question]
}

let questionReducer = Reducer<QuestionState, QuestionAction, QuestionEnvironment> { state, action, environment in
    switch action {
    case let .submitAnswerResponse(.success(httpUrlResponse)):
        if (httpUrlResponse.statusCode == 200) {
            state.showSuccessNotificationBanner = true
            state.submitButtonText = "Already submitted"
            state.answerTextFieldColor = Color.gray
            state.answerTextFieldDisabled = true
            state.numQuestionsSubmitted += 1
            return Effect(value: .setSumbitButtonDisabled)
        } else {
            return Effect(value: .submitAnswerResponse(Result.failure(APIError.runtimeError("Failed to set answer"))))
        }
    case .submitAnswerResponse(.failure):
        state.showFailNotificationBanner = true
        return .none
    case .setSubmitButtonAppearance(answer: let answer):
        if (answer.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return Effect(value: .setSumbitButtonDisabled)
        } else {
            return Effect(value: .setSubmitButtonEnabled)
        }
    case .setSumbitButtonDisabled:
        state.submitButtonForegroundColor = Color.gray
        state.submitButtonBackgroundColor = Color.gray.opacity(0.2)
        state.submitButtonDisabled = true
        return .none
    case .setSubmitButtonEnabled:
        state.submitButtonForegroundColor = Color.blue
        state.submitButtonBackgroundColor = Color.white
        state.submitButtonDisabled = false
        return .none
    case .notificationBannerDismissed:
        state.showSuccessNotificationBanner = false
        state.showFailNotificationBanner = false
        return .none
    case .submitButtonClicked(question: let question):
        return Effect(value: .submitAnswer(question: question))
    case .submitAnswer(question: let question):
        return environment.setAnswerAPICall(question).catchToEffect().map(QuestionAction.submitAnswerResponse)
        
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
    //        state.questionInView = state.questions[state.currentQuestionTag - 1]
    //        state.isPreviousButtonDisabled = state.questionInView == state.questions.first
    //        state.isNextButtonDisabled = state.questionInView == state.questions.last
            return .none
        case .questionSelectionChanged:
            return .none
        case .onAppear:
            return Effect(value: .fetchQuestionsAPICall)
        case .fetchQuestionsAPICall:
            return .task {
                await .getQuestionsListResponse(
                    TaskResult {
                        try await IdentifiedArrayOf(environment.questionsList())
                    })
            }
        case let .getQuestionsListResponse(.success(questionsList)):
            questionsList.forEach({ question in
                state.questions.append(QuestionState(question: question))
            })
            return .none
        case .getQuestionsListResponse(.failure):
            return .none
        case .questionModified(question: let question, position: let position):
    //        state.questions[position] = question
            return .none
        case .question(id: let id, action: let action):
            return .none
        }
    }
)
    .debug()


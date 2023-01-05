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
    var numQuestionsSubmitted = 0
    var currentQuestionTag = 1
    var isPreviousButtonDisabled = true
    var isNextButtonDisabled = false
    var questions: [Question] = []
    var questionInView: Question = Question()
    
    var submitButtonText = "Submit"
    var submitButtonForegroundColor = Color.gray
    var submitButtonBackgroundColor = Color.gray.opacity(0.2)
    var submitButtonDisabled = true
    var answerTextFieldColor = Color.black
    var answerTextFieldDisabled = false
    var showFailNotificationBanner: Bool = false
    var showSuccessNotificationBanner: Bool = false
    //        var notificationBannerFail: NotificationBannerType = NotificationBannerType.fail(retry: Database.setAnswer)
    //        var notificationBannerSuccess: NotificationBannerType = NotificationBannerType.success
}

public enum TabViewAction: Equatable  {
    case previousTapped
    case nextTapped
    case questionOnDisplayChanged(currentQuestionTag: Int)
    case onAppear
    case fetchQuestionsAPICall
    case getQuestionsListResponse(TaskResult<[Question]>)
    case questionSelectionChanged
    case questionModified(question: Question, position: Int)
    case numQuestionsSubmittedChanged(numQuestionsSubmitted: Int)
    
    case submitButtonClicked(question: Question)
    case submitAnswer(question: Question)
    case submitAnswerResponse(TaskResult<HTTPURLResponse>)
    case setSubmitButtonAppearance(answer: String)
    case setSumbitButtonDisabled
    case setSubmitButtonEnabled
    
    case notificationBannerDismissed
}

public enum QuestionAction: Equatable  {
    case submitButtonClicked(question: Question)
    case submitAnswer(question: Question)
    case submitAnswerResponse(TaskResult<HTTPURLResponse>)
    case setSubmitButtonAppearance(answer: String)
    case setSumbitButtonDisabled
    case setSubmitButtonEnabled
    
    case notificationBannerDismissed
}

struct TabViewEnvironment {
    let questionsList: () async throws -> [Question]
    let setAnswerAPICall: (Question) async throws -> HTTPURLResponse
}

let tabViewReducer = Reducer<TabViewState, TabViewAction, TabViewEnvironment> { state, action, environment in
    switch action {
    case .previousTapped:
        return Effect(value: .questionOnDisplayChanged(currentQuestionTag: state.currentQuestionTag - 1))
    case .nextTapped:
        return Effect(value: .questionOnDisplayChanged(currentQuestionTag: state.currentQuestionTag + 1))
    case let .questionOnDisplayChanged(currentQuestionTag):
        state.currentQuestionTag = currentQuestionTag
        state.questionInView = state.questions[state.currentQuestionTag - 1]
        state.isPreviousButtonDisabled = state.questionInView == state.questions.first
        state.isNextButtonDisabled = state.questionInView == state.questions.last
        return .none
    case .questionSelectionChanged:
        return .none
    case .onAppear:
        return Effect(value: .fetchQuestionsAPICall)
    case .fetchQuestionsAPICall:
        return .task {
            await .getQuestionsListResponse(
                TaskResult {
                    try await environment.questionsList()
                })
        }
    case let .getQuestionsListResponse(.success(questionsList)):
        state.questionInView = questionsList.first ?? state.questionInView
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
        
    case .submitButtonClicked(question: let question):
        return Effect(value: .submitAnswer(question: question))
    case .submitAnswer(question: let question):
        return .task {
            await .submitAnswerResponse(
                TaskResult {
                    try await environment.setAnswerAPICall(question)
                })
        }
    case let .submitAnswerResponse(.success(httpUrlResponse)):
        if (httpUrlResponse.statusCode == 200) {
            state.showSuccessNotificationBanner = true
            state.submitButtonText = "Already submitted"
            state.answerTextFieldColor = Color.gray
            state.answerTextFieldDisabled = true
            state.numQuestionsSubmitted += 1
            return Effect(value: .setSumbitButtonDisabled)
        } else {
            return Effect(value: .submitAnswerResponse(TaskResult.failure(APIError.runtimeError("Failed to set answer"))))
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
    }
}
    .debug()


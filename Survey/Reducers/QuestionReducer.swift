//
//  QuestionReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 02/01/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct QuestionReducer: ReducerProtocol {
    let setAnswerAPICall: (Question) async throws -> HTTPURLResponse
    
    public struct State: Equatable {
        var submitButtonText = "Submit"
        var submitButtonForegroundColor = Color.gray
        var submitButtonBackgroundColor = Color.gray.opacity(0.2)
        var submitButtonDisabled = true
        var answerTextFieldColor = Color.black
        var answerTextFieldDisabled = false
        var showFailNotificationBanner: Bool = false
        var showSuccessNotificationBanner: Bool = false
        var notificationBannerFail: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Fail)
        var notificationBannerSuccess: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Success)
    }
    

    public enum Action: Equatable  {
        case submitButtonClicked(question: Question)
        case submitAnswer(question: Question)
        case submitAnswerResponse(TaskResult<HTTPURLResponse>)
        case setSubmitButtonAppearance(answer: String)
        case setSumbitButtonDisabled
        case setSubmitButtonEnabled
        
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .submitButtonClicked(question: let question):
            return Effect(value: .submitAnswer(question: question))
        case .submitAnswer(question: let question):
            return .task {
                await .submitAnswerResponse(
                    TaskResult {
                        try await self.setAnswerAPICall(question)
                  })
              }
        case let .submitAnswerResponse(.success(httpUrlResponse)):
            if (httpUrlResponse.statusCode == 200) {
                state.showSuccessNotificationBanner = true
                state.submitButtonText = "Already submitted"
                state.answerTextFieldColor = Color.gray
                state.answerTextFieldDisabled = true
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
        }
    }
}


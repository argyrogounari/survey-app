//
//  QuestionViewModel.swift
//  Survey
//
//  Created by argyro gounari on 01/11/2022.
//

import Foundation
import SwiftUI

@MainActor class QuestionViewModel: ObservableObject {
    @Published var submitButtonText = "Submit"
    @Published var submitButtonForegroundColor = Color.gray
    @Published var submitButtonBackgroundColor = Color.gray.opacity(0.2)
    @Published var submitButtonDisabled = true
    @Published var answerTextFieldColor = Color.black
    @Published var answerTextFieldDisabled = false
    @Published var showFailNotificationBanner: Bool = false
    @Published var showSuccessNotificationBanner: Bool = false
    @Published var notificationBannerFail: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Fail)
    @Published var notificationBannerSuccess: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Success)
    
    func submitAnswer(question: Question, completion: @escaping (Bool) -> Void) {
        Task {
//            await Database().setAnswer(question: question) {_, isSuccesful in
//                if (isSuccesful) {
//                    showSuccessNotificationBanner = true
//                    submitButtonText = "Already submitted"
//                    disableSubmitButton()
//                    answerTextFieldColor = Color.gray
//                    answerTextFieldDisabled = true
//                    completion(isSuccesful)
//                } else {
//                    showFailNotificationBanner = true
//                }
//            }
        }
    }
    
    func disableSubmitButton() {
        submitButtonForegroundColor = Color.gray
        submitButtonBackgroundColor = Color.gray.opacity(0.2)
        submitButtonDisabled = true
    }
    
    func enableSubmitButton() {
        submitButtonForegroundColor = Color.blue
        submitButtonBackgroundColor = Color.white
        submitButtonDisabled = false
    }
    
    func setStateForSubmitButton(answer: String) {
        if (answer.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            disableSubmitButton()
        } else {
            enableSubmitButton()
        }
    }
}

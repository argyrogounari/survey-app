//
//  WelcomeViewModel.swift
//  Survey
//
//  Created by argyro gounari on 01/11/2022.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture
import Welcome

struct AppState {
    // - MARK: Welcome
    var isShowingDetailView = false
    
    // - MARK: TabView
    var numQuestionsSubmitted = 0
    var currentQuestion = 1
    var isPreviousButtonDisabled = true
    var isNextButtonDisabled = false
    var questions: [Question] = []
    
    var tabViewState: TabViewState {
        get {
            TabViewState(
                numQuestionsSubmitted: self.numQuestionsSubmitted,
                currentQuestion: self.currentQuestion,
                isPreviousButtonDisabled: self.isPreviousButtonDisabled,
                isNextButtonDisabled: self.isNextButtonDisabled,
                questions: self.questions
            )
        }
        set {
            self.numQuestionsSubmitted = newValue.numQuestionsSubmitted
            self.currentQuestion = newValue.currentQuestion
            self.isPreviousButtonDisabled = newValue.isPreviousButtonDisabled
            self.isNextButtonDisabled = newValue.isNextButtonDisabled
            self.questions = newValue.questions
        }
    }
    
    // - MARK: QuestionView
    
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

    var questionViewState: QuestionViewState {
        get {
            QuestionViewState(
                submitButtonText: self.submitButtonText,
                submitButtonForegroundColor: self.submitButtonForegroundColor,
                submitButtonBackgroundColor: self.submitButtonBackgroundColor,
                submitButtonDisabled: self.submitButtonDisabled,
                answerTextFieldColor: self.answerTextFieldColor,
                answerTextFieldDisabled: self.answerTextFieldDisabled,
                showFailNotificationBanner: self.showFailNotificationBanner,
                showSuccessNotificationBanner: self.showSuccessNotificationBanner,
                notificationBannerFail: self.notificationBannerFail,
                notificationBannerSuccess: self.notificationBannerSuccess
            )
        }
        set {
            self.submitButtonText = newValue.submitButtonText
            self.submitButtonForegroundColor = newValue.submitButtonForegroundColor
            self.submitButtonBackgroundColor = newValue.submitButtonBackgroundColor
            self.submitButtonDisabled = newValue.submitButtonDisabled
            self.answerTextFieldColor = newValue.answerTextFieldColor
            self.answerTextFieldDisabled = newValue.answerTextFieldDisabled
            self.showFailNotificationBanner = newValue.showFailNotificationBanner
            self.showSuccessNotificationBanner = newValue.showSuccessNotificationBanner
            self.notificationBannerFail = newValue.notificationBannerFail
            self.notificationBannerSuccess = newValue.notificationBannerSuccess
        }
    }
}

extension AppState {
    var welcomeModal: WelcomeState {
        get {
            WelcomeState(isShowingDetailView: self.isShowingDetailView)
        }
        set {
            self.isShowingDetailView = newValue.isShowingDetailView
        }
    }
}

struct TabViewState {
    var numQuestionsSubmitted: Int
    var currentQuestion: Int
    var isPreviousButtonDisabled: Bool
    var isNextButtonDisabled: Bool
    var questions: [Question]
}

struct QuestionViewState {
    var submitButtonText: String
    var submitButtonForegroundColor: Color
    var submitButtonBackgroundColor: Color
    var submitButtonDisabled: Bool
    var answerTextFieldColor: Color
    var answerTextFieldDisabled: Bool
    var showFailNotificationBanner: Bool
    var showSuccessNotificationBanner: Bool
    var notificationBannerFail: NotificationBannerModifier.NotificationBannerData
    var notificationBannerSuccess: NotificationBannerModifier.NotificationBannerData
}

// - MARK: Actions

enum AppAction {
    case welcome(WelcomeAction)
    case tabView(TabViewAction)
    case questionView(QuestionViewAction)
    
    var welcome: WelcomeAction? {
       get {
         guard case let .welcome(value) = self else { return nil }
         return value
       }
       set {
         guard case .welcome = self, let newValue = newValue else { return }
         self = .welcome(newValue)
       }
     }
    
    var tabView: TabViewAction? {
       get {
         guard case let .tabView(value) = self else { return nil }
         return value
       }
       set {
         guard case .tabView = self, let newValue = newValue else { return }
         self = .tabView(newValue)
       }
     }
    
    var questionView: QuestionViewAction? {
       get {
         guard case let .questionView(value) = self else { return nil }
         return value
       }
       set {
         guard case .questionView = self, let newValue = newValue else { return }
         self = .questionView(newValue)
       }
     }
}


enum TabViewAction {
    case previousTapped
    case nextTapped
    case questionOnDisplayChanged // is this action? maybe effect?
    case tabViewAppeared
}

enum QuestionViewAction {
    case submitButtonTapped
    case answerTextChanged // is this action? maybe effect?
}

// - MARK: Reducers

let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(welcomeReducer, value: \.welcomeModal, action: \.welcome),
    pullback(tabViewReducer, value: \.tabViewState, action: \.tabView),
    pullback(questionViewReducer, value: \.questionViewState, action: \.questionView)
)



func tabViewReducer(state: inout TabViewState, action: TabViewAction) {
    switch action {
    case .previousTapped:
        state.currentQuestion -= 1
    case .nextTapped:
        state.currentQuestion += 1
    case .questionOnDisplayChanged:
        state.isPreviousButtonDisabled = state.currentQuestion == 1
        state.isNextButtonDisabled = state.currentQuestion == state.questions.last?.id
    case .tabViewAppeared:
        Task {
            await Database().getQuestions{ questionsList in
//                state.questions = questionsList
            }
        }
    }
}

func questionViewReducer(state: inout QuestionViewState, action: QuestionViewAction) {
//    switch action {
//    case .submitButtonTapped:
////        submitAnswer
//    case .answerTextChanged:
////        setStateForSubmitButton
//    }
}




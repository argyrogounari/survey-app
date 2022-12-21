//
//  WelcomeViewModel.swift
//  Survey
//
//  Created by argyro gounari on 01/11/2022.
//

import Foundation
import UIKit
import SwiftUI

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
}

struct TabViewState {
    var numQuestionsSubmitted: Int
    var currentQuestion: Int
    var isPreviousButtonDisabled: Bool
    var isNextButtonDisabled: Bool
    var questions: [Question]
}

// - MARK: Actions

enum AppAction {
    case welcome(WelcomeAction)
    case tabView(TabViewAction)
    
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
}

enum WelcomeAction {
    case welcomeTapped
}

enum TabViewAction {
    case previousTapped
    case nextTapped
    case questionOnDisplayChanged // is this action? maybe effect?
    case tabViewAppeared
}

// - MARK: Reducers

let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(welcomeReducer, value: \.isShowingDetailView, action: \.welcome),
    pullback(tabViewReducer, value: \.tabViewState, action: \.tabView)
)

func welcomeReducer(state: inout Bool, action: WelcomeAction) {
    switch action {
    case .welcomeTapped:
        state = true
    }
}

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

func combine<Value, Action> (
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers{
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction> (
_ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
value: WritableKeyPath<GlobalValue, LocalValue>,
action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {return}
        reducer(&globalValue[keyPath: value], localAction)
    }
}

final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    @Published var value: Value
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action: Action) {
        self.reducer(&self.value, action)
    }
}

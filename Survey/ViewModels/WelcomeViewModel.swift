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
    var isShowingDetailView = false
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

// - MARK: Actions

enum AppAction {
    case welcome(WelcomeAction)
    
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
}

enum WelcomeAction {
    case welcomeTapped
}

// - MARK: Reducers

let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(welcomeReducer, value: \.isShowingDetailView, action: \.welcome),
    welcomeReducerTest
)

func welcomeReducer(state: inout Bool, action: WelcomeAction) {
    switch action {
    case .welcomeTapped:
        state = true
    }
}

func welcomeReducerTest(state: inout AppState, action: AppAction) {
//    switch action {
//    case .welcome(.welcomeTapped):
////        state = true
//    }
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

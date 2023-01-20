//
//  AppState.swift
//  Survey
//
//  Created by Argyro Gounari on 20/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture

struct AppState : Equatable {
    var welcome: WelcomeState
    var tabView: TabViewState
    var totalQusetionsSubmitted: TotalQusetionsSubmittedState
}

enum AppAction: Equatable  {
    case welcome(WelcomeAction)
    case tabView(TabViewAction)
    case totalQusetionsSubmitted(TotalQusetionsSubmittedAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let numQuestionsSubmitted: CurrentValueSubject<Int, Never>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    welcomeReducer.pullback(state: \.welcome, action: /AppAction.welcome, environment: { _ in
        WelcomeEnvironment()
    }),
    tabViewReducer.pullback(
        state: \.tabView,
        action: /AppAction.tabView,
        environment: { env in
            TabViewEnvironment(
                mainQueue: env.mainQueue,
                getQuestionsAPICall: Database().getQuestions,
                numQuestionsSubmitted: env.numQuestionsSubmitted
            )
        }
    ),
    totalQusetionsSubmittedReducer.pullback(
        state: \.totalQusetionsSubmitted,
        action: /AppAction.totalQusetionsSubmitted,
        environment: { env in TotalQusetionsSubmittedEnvironment(
            numQuestionsSubmitted: env.numQuestionsSubmitted
        )}
    )
)
    .debug()

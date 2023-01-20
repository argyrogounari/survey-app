//
//  SurveyApp.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import Combine
import ComposableArchitecture

@main
struct SurveyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WelcomeView(
                    store: Store(
                        initialState: AppState(
                            welcome: WelcomeState(),
                            tabView: TabViewState(),
                            totalQusetionsSubmitted: TotalQusetionsSubmittedState()),
                        reducer: appReducer,
                        environment: AppEnvironment(
                            mainQueue: .main,
                            numQuestionsSubmitted: CurrentValueSubject<Int, Never>(0))
                    )
                )
            }
        }
    }
}


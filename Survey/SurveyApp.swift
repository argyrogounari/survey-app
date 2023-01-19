//
//  SurveyApp.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct SurveyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WelcomeView(
                    store: Store(
                        initialState: WelcomeState(),
                        reducer: welcomeReducer,
                        environment: WelcomeEnvironment()
                        )
                )
            }
        }
    }
}


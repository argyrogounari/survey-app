//
//  WelcomeReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 22/12/2022.
//

import Foundation
import ComposableArchitecture


public struct WelcomeState: Equatable {
    var isShowingDetailView = false
}

public enum WelcomeAction: Equatable {
    case welcomeTapped
    case dismissTapped
}

struct WelcomeEnvironment {
}

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnvironment> { state, action, environment in
    switch action {
    case .welcomeTapped:
        state.isShowingDetailView = true
        return .none
    case .dismissTapped:
        state.isShowingDetailView = false
        return .none
    }
}


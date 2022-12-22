//
//  Welcome.swift
//  Welcome
//
//  Created by Argyro Gounari on 22/12/2022.
//

import Foundation

public struct WelcomeState {
    public var isShowingDetailView = false
    
    public init (isShowingDetailView: Bool) {
        self.isShowingDetailView = isShowingDetailView
    }
}

public enum WelcomeAction {
    case welcomeTapped
}

public func welcomeReducer(state: inout WelcomeState, action: WelcomeAction) {
    switch action {
    case .welcomeTapped:
        state.isShowingDetailView = true
    }
}

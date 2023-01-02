//
//  WelcomeReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 22/12/2022.
//

import Foundation
import ComposableArchitecture

public struct WelcomeReducer: ReducerProtocol {
    
    public struct State: Equatable {
        var isShowingDetailView = false
    }
    
    public enum Action: Equatable {
        case welcomeTapped
        case dismissTapped
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .welcomeTapped:
            state.isShowingDetailView = true
            return .none
        case .dismissTapped:
            state.isShowingDetailView = false
            return .none
        }
    }
}

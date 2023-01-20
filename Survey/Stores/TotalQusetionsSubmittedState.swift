//
//  TotalQusetionsSubmittedState.swift
//  Survey
//
//  Created by Argyro Gounari on 20/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture

struct TotalQusetionsSubmittedState: Equatable {
    var num = 0
}

enum TotalQusetionsSubmittedAction: Equatable  {
    case onAppear
    case valueChanged(Int)
}

struct TotalQusetionsSubmittedEnvironment {
    let numQuestionsSubmitted: CurrentValueSubject<Int, Never>
}

let totalQusetionsSubmittedReducer = Reducer<TotalQusetionsSubmittedState, TotalQusetionsSubmittedAction, TotalQusetionsSubmittedEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.numQuestionsSubmitted.map(TotalQusetionsSubmittedAction.valueChanged).eraseToEffect()
    case let .valueChanged(newNum):
        state.num = newNum
        return .none
    }
}

//
//  TotalQusetionsSubmittedView.swift
//  Survey
//
//  Created by Argyro Gounari on 20/01/2023.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct TotalQusetionsSubmittedView: View {
    let store: Store<TotalQusetionsSubmittedState, TotalQusetionsSubmittedAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Text("Questions submitted: \(viewStore.num)")
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Color.yellow))
                .accessibilityIdentifier("questionsSubmittedText")
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

//
//  WelcomeView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Combine
import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store.scope(
            state: \.welcome,
            action: AppAction.welcome
        )) { viewStore in
            VStack {
                NavigationLink(destination: QuestionsTabView(store: store), isActive: viewStore.binding(
                    get: { $0.isShowingDetailView },
                    send: .dismissTapped
                )) { EmptyView() }.navigationTitle("Welcome").navigationBarTitleDisplayMode(.inline)
                
                Spacer()
                
                Button(
                    "Start survey",
                    action: {
                        viewStore.send(.welcomeTapped)
                    }
                )
                .accessibilityIdentifier("startSurveyButton")
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .foregroundColor(Color.blue)
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(Color("backgroundColor"))
        }
    }
}


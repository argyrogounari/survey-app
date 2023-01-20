//
//  QuestionsTabView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import Combine
import SwiftUI
import ComposableArchitecture

struct QuestionsTabView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store.scope(
            state: \.tabView,
            action: AppAction.tabView
        )) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                TotalQusetionsSubmittedView(store: self.store.scope(
                    state: \.totalQusetionsSubmitted,
                    action: AppAction.totalQusetionsSubmitted
                ))
                TabView (selection: viewStore.binding(
                    get: { $0.currentQuestionTag },
                    send: { .questionOnDisplayChanged(currentQuestionTag: $0) }
                )) {
                    ForEachStore(
                        self.store.scope(
                            state: \.tabView,
                            action: AppAction.tabView
                        ).scope(
                            state: \.questions,
                            action: TabViewAction.question
                        )
                    ){
                        questionStore in
                        QuestionView(store: questionStore)
                        .tag(viewStore.questions.id)
                    }
                }
                .swipeActions(content: {})
                .swipeActions(allowsFullSwipe: false, content: {})
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.previousTapped)
                        }) {
                            Text("Previous")
                        }
                        .disabled(viewStore.isPreviousButtonDisabled)
                        .accessibilityIdentifier("previousToolBarButton")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.nextTapped)
                        }) {
                            Text("Next")
                        }
                        .disabled(viewStore.isNextButtonDisabled)
                        .accessibilityIdentifier("nextToolBarButton")
                    }
                }.onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .navigationTitle("Question \(viewStore.currentQuestionTag)/\(viewStore.questions.count)")
        }
    }
}

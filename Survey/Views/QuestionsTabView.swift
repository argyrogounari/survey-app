//
//  QuestionsTabView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct QuestionsTabView: View {
    let store: Store<TabViewState, TabViewAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView (selection: viewStore.binding(
                get: { $0.currentQuestionTag },
                send: { .questionOnDisplayChanged(currentQuestionTag: $0) }
            )) {
                ForEach(0..<viewStore.questions.count, id:\.self) { i in
                    QuestionView(store: store).tag(viewStore.questions[i].id)
                }
            }
            .swipeActions(content: {})
            .swipeActions(allowsFullSwipe: false, content: {})
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.vertical)
            .navigationTitle("Question \(viewStore.currentQuestionTag)/\(viewStore.questions.count)")
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
    }
}

struct QuestionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsTabView(store: Store(
            initialState: TabViewState(),
            reducer: tabViewReducer,
            environment: TabViewEnvironment(
            questionsList: Database().getQuestions,
            setAnswerAPICall: Database().setAnswer)
        ))
    }
}
                         
                         
                         

//
//  QuestionsTabView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct QuestionsTabView: View {
    let store: StoreOf<TabViewReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView (selection: viewStore.binding(
                get: { $0.currentQuestion },
                send: .questionOnDisplayChanged
            )) {
                ForEach(0..<viewStore.questions.count, id:\.self) { i in
                    QuestionView(store: Store(
                        initialState: QuestionReducer.State(),
                        reducer: QuestionReducer(setAnswerAPICall: Database().setAnswer)
                    ), question: viewStore.binding(
                        get: { $0.questions[i] },
                        send: { .questionModified(question: $0, position: i) }
                    ), numQuestionsSubmitted: viewStore.binding(
                        get: { $0.numQuestionsSubmitted },
                        send: { .numQuestionsSubmittedChanged(numQuestionsSubmitted: $0) }
                    ))
                }
            }
            .swipeActions(content: {})
            .swipeActions(allowsFullSwipe: false, content: {})
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.vertical)
            .onChange(of: viewStore.currentQuestion) { _ in
                viewStore.send(.questionOnDisplayChanged)
            }
            .navigationTitle("Question \(viewStore.currentQuestion)/\(viewStore.questions.count)")
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
        QuestionsTabView(store: Store(initialState: TabViewReducer.State(), reducer: TabViewReducer(questionsList: Database().getQuestions))
        )
    }
}

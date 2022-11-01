//
//  QuestionsTabView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI

struct QuestionsTabView: View {
    @StateObject var vm = QuestionsTabViewViewModel()
    
    var body: some View {
        TabView (selection: $vm.currentQuestion) {
            ForEach(0..<$vm.questions.count, id:\.self) { i in
                QuestionView(question: $vm.questions[i], numQuestionsSubmitted: $vm.numQuestionsSubmitted)
            }
        }
        .swipeActions(content: {})
        .swipeActions(allowsFullSwipe: false, content: {})
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.vertical)
        .onChange(of: vm.currentQuestion) { _ in
            vm.changeToolbarButtonStatesOnQuestionChange()
        }
        .navigationTitle("Question \(vm.currentQuestion)/\(vm.questions.count)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    vm.decreaseQuestionNum()
                }) {
                    Text("Previous")
                }
                .disabled(vm.isPreviousButtonDisabled)
                .accessibilityIdentifier("previousToolBarButton")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    vm.increaseQuestionNum()
                }) {
                    Text("Next")
                }
                .disabled(vm.isNextButtonDisabled)
                .accessibilityIdentifier("nextToolBarButton")
            }
        }.onAppear {
            vm.getQuestions()
        }
    }
}

struct QuestionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsTabView()
    }
}

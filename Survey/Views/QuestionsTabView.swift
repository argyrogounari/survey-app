//
//  QuestionsTabView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI

struct QuestionsTabView: View {
    @State private var currentQuestion = 1
    @State private var numQuestionsSubmitted = 0
    @State private var isPreviousButtonDisabled = true
    @State private var isNextButtonDisabled = false
    @State var questions: [Question] = []
    
    var body: some View {
        TabView (selection: $currentQuestion) {
            ForEach(0..<questions.count, id:\.self) { i in
                QuestionView(numQuestionsSubmitted: $numQuestionsSubmitted, question: $questions[i])
            }
        }
        .swipeActions(content: {})
        .swipeActions(allowsFullSwipe: false, content: {})
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.vertical)
        .onChange(of: currentQuestion) { _ in
            isPreviousButtonDisabled = currentQuestion == 1
            isNextButtonDisabled = currentQuestion == questions.last?.id
        }
        .navigationTitle("Question \(currentQuestion)/\(questions.count)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    currentQuestion -= 1
                }) {
                    Text("Previous")
                }
                .disabled(isPreviousButtonDisabled)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    currentQuestion += 1
                }) {
                    Text("Next")
                }
                .disabled(isNextButtonDisabled)
            }
        }.onAppear {
            Task {
                await Database().getQuestions{ questionsList in questions = questionsList
                }
            }
        }
    }
}

struct QuestionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsTabView()
    }
}

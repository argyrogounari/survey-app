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
    @ObservedObject var database = Database()
    
    var body: some View {
        TabView (selection: $currentQuestion) {
            ForEach(0..<database.questions.count, id:\.self) { i in
                QuestionView(numQuestionsSubmitted: $numQuestionsSubmitted, question: database.questions[i])
            }
        }
        .swipeActions(content: {})
        .swipeActions(allowsFullSwipe: false, content: {})
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.vertical)
        .onChange(of: currentQuestion) { _ in
            isPreviousButtonDisabled = currentQuestion == 1
            isNextButtonDisabled = currentQuestion == database.questions.last?.id
        }
        .navigationTitle("Question \(currentQuestion)/\(database.questions.count)")
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
            self.database.getQuestions()
        }
    }
}

struct QuestionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsTabView()
    }
}

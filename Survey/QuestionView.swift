//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI

struct QuestionView: View {
    @State private var currentQuestion = 1
    @State private var numQuestionsSubmitted = 0
    @State private var isPreviousButtonDisabled = true
    @State private var isNextButtonDisabled = false
    @ObservedObject var database = Database()
    
    var body: some View {
        TabView (selection: $currentQuestion) {
            ForEach(0..<database.questions.count, id:\.self) { i in
                VStack {
                    VStack {
                        Text("Questions submitted: \(numQuestionsSubmitted)")
                        Text(database.questions[i].question).font(.title).bold()
                    }
                    TextField("Type here for an answer", text: $database.questions[i].answer)
                }
                .tag(database.questions[i].id)
            }
        }
        .swipeActions(content: {})
        .swipeActions(allowsFullSwipe: false, content: {})
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.vertical)
        .navigationTitle("Question \(currentQuestion)/10")
        .onChange(of: currentQuestion) { _ in
            isPreviousButtonDisabled = currentQuestion == 1
            isNextButtonDisabled = currentQuestion == database.questions.last?.id
        }
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
            self.database.setQuestions()
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}

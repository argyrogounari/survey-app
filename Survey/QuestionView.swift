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
    @State private var submitButtonText = "Submit"
    @ObservedObject var database = Database()
    
    var body: some View {
        TabView (selection: $currentQuestion) {
            ForEach(0..<database.questions.count, id:\.self) { i in
                VStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        Text("Questions submitted: \(numQuestionsSubmitted)")
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Rectangle().fill(Color.yellow))
                        Text(database.questions[i].question)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding([.top, .bottom], 40)
                            .padding([.leading, .trailing], 20)
                    }.background(Rectangle().fill(Color("backgroundColor")))
                    TextField("Type here for an answer", text: $database.questions[i].answer)
                        .padding([.top, .bottom], 40)
                        .padding([.leading, .trailing], 20)
                    HStack {
                        Spacer()
                        Button(submitButtonText, action: {
                            Task {
                                let currentQuestion = database.questions[i]
                                let isSuccesful = await database.setAnswer(question: currentQuestion)
                                if (isSuccesful) {
                                    // Success banner
                                } else {
                                    // Fail banner with retry button
                                }
                            }
                        })
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 35)
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(10)
                        Spacer()
                    }
                    Spacer()
                }
                .tag(database.questions[i].id)
                .background(Rectangle().fill(Color("backgroundColor")))
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

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}

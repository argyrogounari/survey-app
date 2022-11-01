//
//  QuestionsTabViewViewModel.swift
//  Survey
//
//  Created by argyro gounari on 01/11/2022.
//

import Foundation

@MainActor class QuestionsTabViewViewModel: ObservableObject {
    @Published var numQuestionsSubmitted = 0
    @Published var currentQuestion = 1
    @Published var isPreviousButtonDisabled = true
    @Published var isNextButtonDisabled = false
    @Published var questions: [Question] = []
    
    
    func changeToolbarButtonStatesOnQuestionChange() {
        isPreviousButtonDisabled = currentQuestion == 1
        isNextButtonDisabled = currentQuestion == questions.last?.id
    }
    
    func decreaseQuestionNum() {
        currentQuestion -= 1
    }
    
    func increaseQuestionNum() {
        currentQuestion += 1
    }
    
    func getQuestions() {
        Task {
            await Database().getQuestions{ questionsList in
                self.questions = questionsList
            }
        }
    }
}

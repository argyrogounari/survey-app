//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 30/10/2022.
//

import SwiftUI

struct QuestionView: View {
    @State private var currentQuestion = 1
    @Binding var numQuestionsSubmitted: Int
    @State private var isPreviousButtonDisabled = true
    @State private var isNextButtonDisabled = false
    @State private var submitButtonText = "Submit"
    @State private var submitButtonForegroundColor = Color.gray
    @State private var submitButtonBackgroundColor = Color.gray.opacity(0.2)
    @State private var submitButtonDisabled = true
    @State private var answerTextFieldColor = Color.black
    @State private var answerTextFieldDisabled = false
    @ObservedObject var question: Question
    
    @State var showFailNotificationBanner: Bool = false
    @State var showSuccessNotificationBanner: Bool = false
    @State var notificationBannerFail: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Fail)
    @State var notificationBannerSuccess: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Success)
        
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text("Questions submitted: \(numQuestionsSubmitted)")
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Rectangle().fill(Color.yellow))
                Text(question.question)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 40)
                    .padding([.leading, .trailing], 20)
            }.background(Rectangle().fill(Color("backgroundColor")))
            TextField("Type here for an answer", text: $question.answer)
                .padding([.top, .bottom], 40)
                .padding([.leading, .trailing], 20)
                .foregroundColor(answerTextFieldColor)
                .disabled(answerTextFieldDisabled)
                .onChange(of: question.answer) { _ in
                    if (question.answer.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                        disableSubmitButton()
                    } else {
                        enableSubmitButton()
                    }
                }
            HStack {
                Spacer()
                Button(submitButtonText, action: {
                    submitAnswer()
                })
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 35)
                    .foregroundColor(submitButtonForegroundColor)
                    .background(submitButtonBackgroundColor)
                    .cornerRadius(10)
                    .disabled(submitButtonDisabled)
                Spacer()
            }
            Spacer()
        }
        .tag(question.id)
        .background(Rectangle().fill(Color("backgroundColor")))
        .notificatioBanner(data: $notificationBannerSuccess, show: $showSuccessNotificationBanner, retry: {})
        .notificatioBanner(data: $notificationBannerFail, show: $showFailNotificationBanner, retry:  {submitAnswer()}
        )
    }
    
    func submitAnswer() {
        Task {
            let isSuccesful = await Database().setAnswer(question: question)
            if (isSuccesful) {
                showSuccessNotificationBanner = true
                submitButtonText = "Already submitted"
                disableSubmitButton()
                answerTextFieldColor = Color.gray
                answerTextFieldDisabled = true
                numQuestionsSubmitted += 1
            } else {
                showFailNotificationBanner = true
            }
        }
    }
    
    func disableSubmitButton() {
        submitButtonForegroundColor = Color.gray
        submitButtonBackgroundColor = Color.gray.opacity(0.2)
        submitButtonDisabled = true
    }
    
    func enableSubmitButton() {
        submitButtonForegroundColor = Color.blue
        submitButtonBackgroundColor = Color.white
        submitButtonDisabled = false
    }
}

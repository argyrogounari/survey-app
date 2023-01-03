//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 30/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct QuestionView: View {
    let store: StoreOf<TabViewReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("Questions submitted: \(viewStore.numQuestionsSubmitted)")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(Color.yellow))
                        .accessibilityIdentifier("questionsSubmittedText")
                    Text(viewStore.questionInView.question)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding([.top, .bottom], 40)
                        .padding([.leading, .trailing], 20)
                        .accessibilityIdentifier("questionText")
                }.background(Rectangle().fill(Color("backgroundColor")))
                TextField("Type here for an answer",
                          text: viewStore.binding(
                            get: { $0.questionInView.answer },
                            send: { .setSubmitButtonAppearance(answer: $0) }
                        ))
                    .padding([.top, .bottom], 40)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(viewStore.answerTextFieldColor)
                    .disabled(viewStore.answerTextFieldDisabled)
//                    .onChange(of: viewStore.question.answer) { _ in
//                        viewStore.send(.setSubmitButtonAppearance(answer: viewStore.question.answer))
//                    }
                    .accessibilityIdentifier("answerTextField")
                HStack {
                    Spacer()
                    Button(viewStore.submitButtonText, action: {
                        viewStore.send(.submitButtonClicked(question: viewStore.questionInView))
//                        vm.submitAnswer(question: question) { isSuccesful in
//                            numQuestionsSubmitted += 1 // TODO
//                        }
                    })
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 35)
                    .foregroundColor(viewStore.submitButtonForegroundColor)
                    .background(viewStore.submitButtonBackgroundColor)
                    .cornerRadius(10)
                    .disabled(viewStore.submitButtonDisabled)
                    .accessibilityIdentifier("submitButton")
                    Spacer()
                }
                Spacer()
            }

            .background(Rectangle().fill(Color("backgroundColor")))
//            .notificatioBanner(data: $vm.notificationBannerSuccess, show: $vm.showSuccessNotificationBanner, retry: {})
//            .notificatioBanner(data: $vm.notificationBannerFail, show: $vm.showFailNotificationBanner, retry:  {vm.submitAnswer(question: question, completion: {isSuccessflul in numQuestionsSubmitted += 1})})
        }
    }
}


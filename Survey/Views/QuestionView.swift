//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 30/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct QuestionView: View {
    let store: Store<QuestionState, QuestionAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("Questions submitted: \(viewStore.numQuestionsSubmitted)")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(Color.yellow))
                        .accessibilityIdentifier("questionsSubmittedText")
                    Text(viewStore.question.question)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding([.top, .bottom], 40)
                        .padding([.leading, .trailing], 20)
                        .accessibilityIdentifier("questionText")
                }.background(Rectangle().fill(Color("backgroundColor")))
                TextField("Type here for an answer",
                          text: viewStore.binding(
                            get: { $0.question.answer },
                            send: { .setSubmitButtonAppearance(answer: $0) }
                        ))
                    .padding([.top, .bottom], 40)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(viewStore.answerTextFieldColor)
                    .disabled(viewStore.answerTextFieldDisabled)
                    .accessibilityIdentifier("answerTextField")
                HStack {
                    Spacer()
                    Button(viewStore.submitButtonText, action: {
                        viewStore.send(.submitButtonClicked(question: viewStore.question))
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
            .notificatioBanner(type: NotificationBannerType.success, isActive: viewStore.binding(
                                    get: { $0.showSuccessNotificationBanner },
                                    send: .notificationBannerDismissed
                                ))
            .notificatioBanner(type: NotificationBannerType.fail, isActive: viewStore.binding(
                                    get: { $0.showFailNotificationBanner },
                                    send: .notificationBannerDismissed
                                ))
        }
    }
}


//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 30/10/2022.
//

import SwiftUI
import ComposableArchitecture

enum AnswerTextFieldState {
    case enabled
    case disabled
}

enum SubmitButtonState {
    case enabled
    case disableQuestionNotSubmitted
    case disableQuestionSubmitted
}

struct QuestionView: View {
    let store: Store<QuestionState, QuestionAction>
    @State var answerTextFieldColor = Color.black
    @State var answerTextFieldDisabled = false
    @State var submitButtonText = "Submit"
    @State var submitButtonForegroundColor = Color.gray
    @State var submitButtonBackgroundColor = Color.gray.opacity(0.2)
    @State var submitButtonDisabled = true
    
    func changeAnswerTextFieldAppearance(state: AnswerTextFieldState) {
        switch state {
        case .enabled:
            answerTextFieldColor = Color.black
            answerTextFieldDisabled = false
        case .disabled:
            answerTextFieldColor = Color.gray
            answerTextFieldDisabled = true
        }
    }
    
    func changeSubmitButtonAppearance(state: SubmitButtonState) {
        switch state {
        case .enabled:
            submitButtonText = "Submit"
            submitButtonForegroundColor = Color.blue
            submitButtonBackgroundColor = Color.white
            submitButtonDisabled = false
        case .disableQuestionNotSubmitted:
            submitButtonText = "Submit"
            submitButtonForegroundColor = Color.gray
            submitButtonBackgroundColor = Color.gray.opacity(0.2)
            submitButtonDisabled = true
        case .disableQuestionSubmitted:
            submitButtonText = "Already submitted"
            submitButtonForegroundColor = Color.gray
            submitButtonBackgroundColor = Color.gray.opacity(0.2)
            submitButtonDisabled = true
        }
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
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
                .foregroundColor(answerTextFieldColor)
                .disabled(answerTextFieldDisabled)
                .accessibilityIdentifier("answerTextField")
                HStack {
                    Spacer()
                    Button(submitButtonText, action: {
                        viewStore.send(.submitButtonClicked)
                    })
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 35)
                    .foregroundColor(submitButtonForegroundColor)
                    .background(submitButtonBackgroundColor)
                    .cornerRadius(10)
                    .disabled(submitButtonDisabled)
                    .accessibilityIdentifier("submitButton")
                    Spacer()
                }
                Spacer()
            }
            .background(Rectangle().fill(Color("backgroundColor")))
            .onChange(of: viewStore.submitButtonState,
                      perform: changeSubmitButtonAppearance(state:)
            )
            .onChange(of: viewStore.answerTextFieldState,
                      perform: changeAnswerTextFieldAppearance(state:)
            )
            .notificatioBanner(type: NotificationBannerType.success(isActive: viewStore.binding(
                get: { $0.showSuccessNotificationBanner },
                send: .notificationBannerDismissed
            )))
            .notificatioBanner(type: NotificationBannerType.fail(isActive: viewStore.binding(
                get: { $0.showFailNotificationBanner },
                send: .notificationBannerDismissed
            ), retry: viewStore.binding(
                get: { $0.retryFromNotificationBanner },
                send: .notificationBannerRetryPressed
            )))
        }
    }
}

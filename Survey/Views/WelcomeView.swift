//
//  WelcomeView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: StoreOf<WelcomeReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                NavigationLink(destination: QuestionsTabView(store: Store(
                    initialState: TabViewReducer.State(),
                    reducer: TabViewReducer(questionsList: Database().getQuestions)
                )), isActive: viewStore.binding(
                    get: { $0.isShowingDetailView },
                    send: .dismissTapped
                )) { EmptyView() }.navigationTitle("Welcome").navigationBarTitleDisplayMode(.inline)
                
                Spacer()
                
                Button(
                    "Start survey",
                    action: {
                        viewStore.send(.welcomeTapped)
                    }
                )
                .accessibilityIdentifier("startSurveyButton")
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .foregroundColor(Color.blue)
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(Color("backgroundColor"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView( store: Store(
            initialState: WelcomeReducer.State(),
            reducer: WelcomeReducer()
        ))
    }
}

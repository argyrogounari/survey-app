//
//  WelcomeView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    @StateObject var store = Store(initialValue: AppState(), reducer: appReducer)
    @State var isShowingDetailView = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: QuestionsTabView(), isActive: $isShowingDetailView) { EmptyView() }.navigationTitle("Welcome").navigationBarTitleDisplayMode(.inline)
            
            Spacer()
            
            Button(
                "Start survey",
                action: {
                    isShowingDetailView = true
                    store.send(.welcome(.welcomeTapped))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

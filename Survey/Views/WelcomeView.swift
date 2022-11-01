//
//  WelcomeView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isShowingDetailView = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: QuestionsTabView(), isActive: $isShowingDetailView) { EmptyView() }.navigationTitle("Welcome").navigationBarTitleDisplayMode(.inline)
            
            Spacer()
            
            Button(
                "Start survey",
                action: {
                    self.isShowingDetailView = true
                }
            )
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

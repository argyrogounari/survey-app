//
//  QuestionView.swift
//  Survey
//
//  Created by argyro gounari on 29/10/2022.
//

import SwiftUI

struct QuestionView: View {
    var body: some View {
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle("Question 1/10")
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                        print("Refresh")
                      }) {
                        Text("Previous")
                      }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                        print("Refresh")
                      }) {
                          Text("Next")
                      }
                    }
                  }
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}

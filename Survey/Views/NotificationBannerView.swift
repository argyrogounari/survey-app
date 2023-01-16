//
//  NotificationBannerModifier.swift
//  Survey
//
//  Created by argyro gounari on 31/10/2022.
//

import SwiftUI

enum NotificationBannerType {
    case success(isActive: Binding<Bool>)
    case fail(isActive: Binding<Bool>, retry: Binding<Bool>)
}

struct NotificationBannerModifier: ViewModifier {
    var type: NotificationBannerType

    func body(content: Content) -> some View {
        ZStack {
            content
            switch type {
            case let .success(isActive):
                SuccessBannerView(isActive: isActive)
            case let  .fail(isActive, retry):
                FailBannerView(isActive: isActive, retry: retry)
            }
        }
    }
}

struct SuccessBannerView: View {
    @Binding var isActive: Bool
    @State var makeBannerDisappear: DispatchWorkItem?
    
    let title = "Success!"
    let backgroundColor = Color.green
    
    var body: some View {
            if (isActive) {
                VStack {
                    HStack {
                        Text(title)
                            .bold()
                            .font(.title)
                        Spacer()
                    }
                    .padding(12)
                    .background(backgroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .onTapGesture {
                    withAnimation {
                        self.isActive = false
                        makeBannerDisappear?.cancel()
                    }
                }.onAppear(perform: {
                    makeBannerDisappear = DispatchWorkItem {
                        withAnimation {
                            self.isActive = false
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: makeBannerDisappear!)
                })
                .padding()
                .accessibility(addTraits: .isButton)
                .accessibilityIdentifier("notificationBanner")
            }

    }
}

struct FailBannerView: View {
    @Binding var isActive: Bool
    @Binding var retry: Bool
    @State var makeBannerDisappear: DispatchWorkItem?
    
   let title = "Fail!"
   let backgroundColor = Color.red
    
    var body: some View {
            if (isActive) {
                VStack {
                    HStack {
                        Text(title)
                            .bold()
                            .font(.title)
                        Spacer()
                        Button(action: {
                           makeBannerDisappear?.cancel()
                           self.isActive = false
                           retry = true
                       }){
                           HStack {
                               Text("RETRY")
                                   .bold()
                           }
                           .padding(10)
                           .foregroundColor(.white)
                           .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(Color.white, lineWidth: 2)
                           )
                       }
                    }
                    .padding(12)
                    .background(backgroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .onTapGesture {
                    withAnimation {
                        self.isActive = false
                        makeBannerDisappear?.cancel()
                    }
                }.onAppear(perform: {
                    makeBannerDisappear = DispatchWorkItem {
                        withAnimation {
                            self.isActive = false
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: makeBannerDisappear!)
                })
                .padding()
                .accessibility(addTraits: .isButton)
                .accessibilityIdentifier("notificationBanner")
            }
    }
}



extension View {
    func notificatioBanner(type: NotificationBannerType) -> some View {
        self.modifier(NotificationBannerModifier(type: type))
    }
}


//
//  NotificationBannerModifier.swift
//  Survey
//
//  Created by argyro gounari on 31/10/2022.
//

import SwiftUI

enum NotificationBannerType {
    case success
    case fail // (retry: Binding<Bool>)
}

struct NotificationBannerModifier: ViewModifier {
    private var title: String
    private var backgroundColor: Color
    @Binding private var isActive: Bool
    @State private var makeBannerDisappear: DispatchWorkItem?
    
    init(type: NotificationBannerType, isActive: Binding<Bool>) {
        switch type {
        case .success:
            self.title = "Success!"
            self.backgroundColor = Color.green
        case .fail:
            self.title = "Fail!"
            self.backgroundColor = Color.red
        }
        
        self._isActive = isActive
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if (isActive) {
                VStack {
                    HStack {
                        Text(title)
                            .bold()
                            .font(.title)
                        Spacer()
//                        if (retry != nil) {
//                            Button(action: {
//                                makeBannerDisappear?.cancel()
//                                self.isActive = false
//                                self.retry = true
//                            }){
//                                HStack {
//                                    Text("RETRY")
//                                        .bold()
//                                }
//                                .padding(10)
//                                .foregroundColor(.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.white, lineWidth: 2)
//                                )
//                            }
//                        }
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
}

extension View {
    func notificatioBanner(type: NotificationBannerType, isActive: Binding<Bool>) -> some View {
        self.modifier(NotificationBannerModifier(type: type, isActive: isActive))
    }
}


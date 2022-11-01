//
//  NotificationBannerModifier.swift
//  Survey
//
//  Created by argyro gounari on 31/10/2022.
//

import SwiftUI

struct NotificationBannerModifier: ViewModifier {
    @Binding var data: NotificationBannerData
    @Binding var show: Bool
    var retry: () -> Void
    @State private var makeBannerDisappear: DispatchWorkItem?
    
    struct NotificationBannerData {
        let type: NotificationBannerType
    }
    
    enum NotificationBannerType {
        case Success
        case Fail
        
        var title: String {
            switch self {
            case .Success:
                return "Success!"
            case .Fail:
                return "Failure!"
            }
        }
        
        var buttonText: String {
            switch self {
            case .Success:
                return ""
            case .Fail:
                return "RETRY"
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .Success:
                return Color.green
            case .Fail:
                return Color.red
            }
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if (show) {
                VStack {
                    HStack {
                        Text(data.type.title)
                            .bold()
                            .font(.title)
                        Spacer()
                        if (data.type == .Fail) {
                            Button(action: {
                                makeBannerDisappear?.cancel()
                                self.show = false
                                self.retry()
                            }){
                                HStack {
                                    Text(data.type.buttonText)
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
                    }
                    .padding(12)
                    .background(data.type.backgroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .onTapGesture {
                    withAnimation {
                        self.show = false
                        makeBannerDisappear?.cancel()
                    }
                }.onAppear(perform: {
                    makeBannerDisappear = DispatchWorkItem {
                        withAnimation {
                            self.show = false
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
    func notificatioBanner(data: Binding<NotificationBannerModifier.NotificationBannerData>, show: Binding<Bool>, retry: @escaping () -> Void) -> some View {
        self.modifier(NotificationBannerModifier(data: data, show: show, retry: retry))
    }
}


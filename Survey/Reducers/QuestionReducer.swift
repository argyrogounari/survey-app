//
//  QuestionReducer.swift
//  Survey
//
//  Created by Argyro Gounari on 02/01/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct QuestionReducer: ReducerProtocol {
    
    public struct State: Equatable {
        var submitButtonText = "Submit"
        var submitButtonForegroundColor = Color.gray
        var submitButtonBackgroundColor = Color.gray.opacity(0.2)
        var submitButtonDisabled = true
        var answerTextFieldColor = Color.black
        var answerTextFieldDisabled = false
        var showFailNotificationBanner: Bool = false
        var showSuccessNotificationBanner: Bool = false
        var notificationBannerFail: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Fail)
        var notificationBannerSuccess: NotificationBannerModifier.NotificationBannerData = NotificationBannerModifier.NotificationBannerData(type: .Success)
    }
    

    public enum Action: Equatable  {
        
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
    
}

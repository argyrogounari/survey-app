//
//  WelcomeViewModel.swift
//  Survey
//
//  Created by argyro gounari on 01/11/2022.
//

import Foundation
import UIKit

@MainActor class WelcomeViewModel: ObservableObject {
    @Published var isShowingDetailView = false
    
    func showDetailView() {
        isShowingDetailView = true
    }
}

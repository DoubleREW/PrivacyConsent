//
//  PrivacyConsentViewModel.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI

class PrivacyConsentViewModel : ObservableObject {
    private let consentManager: PrivacyConsentManager
    let text: String = """
This app collects anonymous data about usage and crash reports, these data help to fix bugs quickly and make the app grow update after update.
Tap Accept if you want to allow the app to collect anonymous info, or tap Customize if you want to choose which info share with the developer.
"""
    var privacyPolicyUrl: URL? {
        consentManager.privacyPolicyUrl
    }

    init(consentManager: PrivacyConsentManager = .default) {
        self.consentManager = consentManager
    }

    func acceptAndClose() {
        consentManager.consentAll()
        consentManager.dismissConsentsCrontroller()
    }
}

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

    @Published var customizeSheetVisible: Bool = false

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

    @available(macOS 10.15, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    func open(_ url: URL) {
        #if canImport(AppKit)
        NSWorkspace.shared.open(url)
        #endif
    }
}

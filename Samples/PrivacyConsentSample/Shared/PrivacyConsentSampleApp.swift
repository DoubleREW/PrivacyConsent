//
//  PrivacyConsentSampleApp.swift
//  Shared
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI
import PrivacyConsent

@main
struct PrivacyConsentSampleApp: App {
    @State
    private var consentManager: PrivacyConsentManager = {
        let cm = PrivacyConsentManager()
        cm.configure(
            supportedConsentTypes: [
                .crashReports,
                .usageStats,
                .personalizedAds
            ],
            privacyPolicyUrl: URL(string: "https://google.com")!
        )

        return cm
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .privacyConsentContext()
                .environment(consentManager)
        }
    }
}

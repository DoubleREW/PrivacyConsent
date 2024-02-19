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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .privacyConsentContext(
                    supportedConsentTypes: [
                        .crashReports,
                        .usageStats,
                        .personalizedAds
                    ],
                    privacyPolicyUrl: URL(string: "https://google.com")!
                )
        }
    }
}

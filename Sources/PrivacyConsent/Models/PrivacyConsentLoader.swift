//
//  File.swift
//
//
//  Created by Fausto Ristagno on 19/11/21.
//

import Foundation

/// Loader for mocks usable in SwiftUI previews
class PrivacyConsentLoader : ObservableObject {
    init() {
        PrivacyConsentManager.configure(
            supportedConsentTypes: [.crashReports, .usageStats, .personalizedAds],
            privacyPolicyUrl: URL(string: "https://google.com")!)
    }
}

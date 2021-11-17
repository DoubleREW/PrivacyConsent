//
//  PrivacyChoicesViewModel.swift
//  
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI
import Combine

class PrivacyChoicesViewModel : ObservableObject {
    @Published var consents: [Consent]
    private var ncConsensDidChangeCancellable: Cancellable?
    
    init() {
        PrivacyConsentManager.configure(
            supportedConsentTypes: [.crashReports, .usageStats, .personalizedAds],
            privacyPolicyUrl: URL(string: "https://google.com")!)
        
        self.consents = PrivacyConsentManager.default.supportedConsentTypes.map {
            Consent(type: $0, status: PrivacyConsentManager.default.consentStatus(for: $0))
        }
        
        self.ncConsensDidChangeCancellable = NotificationCenter.default
            .publisher(for: PrivacyConsentManager.consentDidChangeNotification)
            .sink { notification in
                guard let userInfo = notification.userInfo as? [String: Any] else { return }
                
                if let changedConsentType = userInfo["consent"] as? ConsentType {
                    if let index = self.consents.enumerated().filter({ $1.type.rawValue == changedConsentType.rawValue }).map({ $0.offset }).first {
                        let newStatus = PrivacyConsentManager.default.consentStatus(for: changedConsentType)
                        self.consents[index].status = newStatus
                    }
                } else {
                    self.consents = PrivacyConsentManager.default.supportedConsentTypes.map {
                        Consent(type: $0, status: PrivacyConsentManager.default.consentStatus(for: $0))
                    }
                }
            }
    }
}

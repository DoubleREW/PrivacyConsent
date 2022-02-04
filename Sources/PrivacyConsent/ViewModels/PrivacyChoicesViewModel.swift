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
    private var consentManager: PrivacyConsentManager
    private var subscriptions = Set<AnyCancellable>()

    init(consentManager: PrivacyConsentManager = .default, consents: [Consent] = []) {
        self.consentManager = consentManager
        self.consents = consents
    }

    func loadConsents() {
        self.consents = self.consentManager.supportedConsentTypes.map {
            Consent(type: $0, status: self.consentManager.consentStatus(for: $0))
        }

        self.$consents
            .dropFirst()
            .sink { consents in
                self.saveConsentsStatus(consents: consents)
            }
            .store(in: &subscriptions)
    }

    func close() {
        self.forceSetMissingConsents()
        self.dissmiss()
    }

    func acceptAll() {
        var consentsClone = self.consents
        self.consents.enumerated().forEach { (i, consent) in
            if !consent.granted {
                consentsClone[i].granted = true
            }
        }

        self.consents = consentsClone

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.dissmiss()
        }
    }

    func updateConsentsStatus() {
        self.saveConsentsStatus(consents: self.consents)
    }

    private func dissmiss() {
        self.consentManager.dismissConsentsCrontroller()
    }

    private func saveConsentsStatus(consents: [Consent]) {
        consents.forEach { consent in
            self.consentManager.setConsent(consent.type, status: consent.status)
        }
    }

    private func forceSetMissingConsents() {
        let unknownConsents = self.consents.filter {
            self.consentManager.consentStatus(for: $0.type) == .unknown
        }

        self.saveConsentsStatus(consents: unknownConsents)
    }
}

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
    // private var ncConsensDidChangeCancellable: Cancellable?
    private var consentsCancellable: Cancellable?

    init(consentManager: PrivacyConsentManager = .default) {
        self.consentManager = consentManager
        self.consents = []
    }

    func loadConsents() {
        self.consents = self.consentManager.supportedConsentTypes.map {
            Consent(type: $0, status: self.consentManager.consentStatus(for: $0))
        }

        self.consentsCancellable = self.$consents.dropFirst().sink { consents in
            self.saveConsentsStatus(consents: consents)
        }
    }

    func close() {
        consentManager.dismissConsentsCrontroller()
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
            self.close()
        }
    }

    func updateConsentsStatus() {
        self.saveConsentsStatus(consents: self.consents)
    }

    private func saveConsentsStatus(consents: [Consent]) {
        consents.forEach { consent in
            self.consentManager.setConsent(consent.type, status: consent.granted ? .grant : .denied)
        }
    }
}

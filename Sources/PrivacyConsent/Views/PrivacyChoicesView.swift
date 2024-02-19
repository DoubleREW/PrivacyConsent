//
//  PrivacyChoicesView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import SwiftUI

struct PrivacyChoicesView: View {
    @Environment(PrivacyConsentManager.self)
    private var consentManager

    private let completionCallback: (() -> Void)?

    @State
    private var consents: [Consent] = []

    init(onCompletion completionCallback: (() -> Void)? = nil) {
        self.completionCallback = completionCallback
    }

    var body: some View {
        VStack {
            List {
                ForEach($consents) { consent in
                    ConsentView(consent: consent)
                }
            }
            Spacer()
            VStack {
                Button(String(localized: "Accept all", bundle: .module)) {
                    acceptAll()
                }
                .buttonStyle(.primary)
                Button(String(localized: "Close", bundle: .module)) {
                    close()
                }
                .buttonStyle(.secondary)
            }
            .padding()
        }
        .onAppear(perform: {
            loadConsents()
        })
        .onDisappear(perform: {
            updateConsentsStatus()
        })
        .onChange(of: consents) { _, newValue in
            saveConsentsStatus(consents: newValue)
        }
    }

    private func loadConsents() {
        self.consents = consentManager.supportedConsentTypes.map {
            Consent(type: $0, status: consentManager.consentStatus(for: $0))
        }
    }

    private func close() {
        forceSetMissingConsents()
        completionCallback?()
    }

    private func acceptAll() {
        var consentsClone = consents
        consents.enumerated().forEach { (i, consent) in
            if !consent.granted {
                consentsClone[i].granted = true
            }
        }

        self.consents = consentsClone

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            completionCallback?()
        }
    }

    private func updateConsentsStatus() {
        let changedConsents = consents.filter {
            consentManager.consentStatus(for: $0.type) != $0.status
        }

        saveConsentsStatus(consents: changedConsents)
    }

    private func saveConsentsStatus<C>(consents: C) where C: Collection, C.Element == Consent {
        consents.forEach { consent in
            consentManager.setConsent(consent.type, status: consent.status)
        }
    }

    private func forceSetMissingConsents() {
        let unknownConsents = self.consents.filter {
            consentManager.consentStatus(for: $0.type) == .unknown
        }

        saveConsentsStatus(consents: unknownConsents)
    }
}

struct PrivacyChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let consentManager = PrivacyConsentManager()

        NavigationStack {
            PrivacyChoicesView()
        }
        .onAppear(perform: {
            consentManager.configure(
                supportedConsentTypes: [.crashReports, .usageStats],
                storage: InMemoryPrivacyConsentStorage()
            )
        })
        .environment(consentManager)
    }
}

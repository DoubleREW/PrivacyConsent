//
//  PrivacyConsentContext.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

import SwiftUI

public struct PrivacyConsentContext: ViewModifier {
    @State
    private var consentManager = PrivacyConsentManager()

    @State
    private var isConsentModalPresented = false

    private var supportedConsentTypes: [ConsentType]!
    private var privacyPolicyUrl: URL?
    private var storage: PrivacyConsentStorage = UserDefaults.standard

    init(supportedConsentTypes: [ConsentType], privacyPolicyUrl: URL?, storage: any PrivacyConsentStorage) {
        self.supportedConsentTypes = supportedConsentTypes
        self.privacyPolicyUrl = privacyPolicyUrl
        self.storage = storage
    }

    public func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                #if DEBUG
                let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
                let _storage = isPreview ? InMemoryPrivacyConsentStorage() : storage
                #else
                let _storage = storage
                #endif
                consentManager.configure(
                    supportedConsentTypes: supportedConsentTypes,
                    privacyPolicyUrl: privacyPolicyUrl,
                    storage: _storage
                )

                if consentManager.hasMissingConsents {
                    self.isConsentModalPresented = true
                }
            })
            .onChange(of: consentManager.hasMissingConsents, { _, newValue in
                if newValue {
                    self.isConsentModalPresented = true
                }
            })
            .sheet(isPresented: $isConsentModalPresented, content: {
                PrivacyConsentView()
                    // Quando richiamata volontariamente, la modale può essere chiusa senza esprimere consenso
                    .interactiveDismissDisabled(consentManager.hasMissingConsents)
            })
            .environment(\.presentPrivacyConsentModal, PresentConsentModalAction({
                isConsentModalPresented = true
            }))
            .environment(consentManager)
    }
}

public extension View {
    func privacyConsentContext(
        supportedConsentTypes: [ConsentType] = [.usageStats, .crashReports],
        privacyPolicyUrl: URL? = nil,
        storage: any PrivacyConsentStorage = UserDefaults.standard
    ) -> some View {
        self
            .modifier(PrivacyConsentContext(
                supportedConsentTypes: supportedConsentTypes,
                privacyPolicyUrl: privacyPolicyUrl,
                storage: storage
            ))
    }
}

#if DEBUG
fileprivate struct PrivacyConsentContextSampleView : View {
    @Environment(\.presentPrivacyConsentModal)
    private var presentPrivacyConsentModal

    var body: some View {
        VStack {
            Text(verbatim: "My View")
            Button(String("Open Consent Modal")) {
                presentPrivacyConsentModal()
            }
        }
    }
}
#endif

#Preview {
    PrivacyConsentContextSampleView()
        .privacyConsentContext(supportedConsentTypes: [.crashReports, .usageStats])
}

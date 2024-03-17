//
//  PrivacyConsentContext.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

import SwiftUI

public struct PrivacyConsentContext: ViewModifier {
    @Environment(PrivacyConsentManager.self)
    private var consentManager

    @State
    private var isConsentModalPresented = false

    init() { }

    public func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                #if DEBUG
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    consentManager.setStorage(InMemoryPrivacyConsentStorage())
                }
                #endif

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
    func privacyConsentContext() -> some View {
        self
            .modifier(PrivacyConsentContext())
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

#Preview {
    let consentManager = {
        let consentManager = PrivacyConsentManager()
        consentManager.configure(
            supportedConsentTypes: [.crashReports, .usageStats],
            privacyPolicyUrl: URL(string: "https://doublerew.net/legal/app-privacy-policy")!,
            storage: InMemoryPrivacyConsentStorage()
        )

        return consentManager
    }()
    return PrivacyConsentContextSampleView()
        .privacyConsentContext()
        .environment(consentManager)
}
#endif

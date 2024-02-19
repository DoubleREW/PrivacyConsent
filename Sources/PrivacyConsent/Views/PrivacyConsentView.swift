//
//  PrivacyConsentView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI

public struct PrivacyConsentView : View {
    @Environment(PrivacyConsentManager.self)
    private var consentManager

    @Environment(\.dismiss)
    private var dismiss

    public init() { }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                ScrollView {
                    Image("PrivacyIcon", bundle: Bundle.module)
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 96, height: 96)
                        .padding()
                    Text(consentManager.introText)
                    if let url = consentManager.privacyPolicyUrl {
                        #if !os(macOS)
                        NavigationLink(destination: BrowserView(url: url)) {
                            Text("Read more", bundle: .module)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        #else
                        Link(String(localized: "Read more", bundle: .module), destination: url)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        #endif
                    }
                }
                Spacer()
                Button(String(localized: "Accept", bundle: .module)) {
                    acceptAndClose()
                }
                .buttonStyle(.primary)
                NavigationLink(String(localized: "Customize", bundle: .module), destination: {
                    PrivacyChoicesView() {
                        dismiss()
                    }
                })
                .buttonStyle(.secondary)
                if !consentManager.hasMissingConsents {
                    Button(String(localized: "Close", bundle: .module)) {
                        dismiss()
                    }
                    .buttonStyle(.secondary)
                }
            }
            .padding()
            #if !os(macOS)
            .navigationBarHidden(false)
            .navigationBarTitle(String(localized: "Privacy Consent", bundle: .module), displayMode: .inline)
            #endif
        }
    }

    private func acceptAndClose() {
        consentManager.consentAll()
        dismiss()
    }
}

struct PrivacyConsentView_Previews : PreviewProvider {
    static var previews: some View {
        let consentManager = PrivacyConsentManager()

        NavigationStack {
            PrivacyConsentView()
        }
        .onAppear(perform: {
            consentManager.configure(
                supportedConsentTypes: [.crashReports, .usageStats],
                privacyPolicyUrl: URL(string: "https://doublerew.net")!,
                storage: InMemoryPrivacyConsentStorage()
            )
        })
        .environment(consentManager)
    }
}

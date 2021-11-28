//
//  PrivacyChoicesView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import SwiftUI

struct PrivacyChoicesView: View {
    @EnvironmentObject var vm: PrivacyChoicesViewModel

    var body: some View {
        VStack {
            List($vm.consents) { consent in
                ConsentView(consent: consent)
            }
            Spacer()
            VStack {
                Button("Accept all") {
                    vm.acceptAll()
                }
                .buttonStyle(.primary)
                Button("Close") {
                    vm.close()
                }
                .buttonStyle(.secondary)
            }
            .padding()
        }
        .onAppear {
            vm.loadConsents()
        }
        .onDisappear {
            vm.updateConsentsStatus()
        }
    }
}

struct PrivacyChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyChoicesView()
            .environmentObject(PrivacyConsentLoader())
            .environmentObject(PrivacyChoicesViewModel(consents: [
                Consent(type: .usageStats, status: .denied),
                Consent(type: .crashReports, status: .grant),
                Consent(type: .personalizedAds, status: .unknown),
            ]))
    }
}

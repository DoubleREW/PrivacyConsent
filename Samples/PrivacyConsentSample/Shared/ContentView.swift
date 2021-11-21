//
//  ContentView.swift
//  Shared
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI
import PrivacyConsent

struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack(alignment: .center) {
            Button("Mostra") {
                PrivacyConsentManager.default.presentConsentsController(
                    ifNeeded: false, allowsClose: false)
            }
            Button("Mostra (Richiudibile)") {
                PrivacyConsentManager.default.presentConsentsController(
                    ifNeeded: false, allowsClose: true)
            }
        }
        .onAppear {
            PrivacyConsentManager.configure(
                supportedConsentTypes: [
                    .crashReports,
                    .usageStats,
                    .personalizedAds
                ],
                privacyPolicyUrl: URL(string: "https://google.com")!)
        }
        .accentColor(.orange)
        #if os(macOS)
        .frame(width: 640, height: 480)
        #endif
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

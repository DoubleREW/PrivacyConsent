//
//  PrivacyConsentModalView.swift
//
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI

struct PrivacyConsentModalView: View {
    var consentView: some View {
        #if !os(macOS)
        PrivacyConsentNavigationView()
        #else
        PrivacyConsentView()
            .frame(width: 360, height: 480)
        #endif
    }

    var body: some View {
        consentView
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
    }
}

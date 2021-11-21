//
//  PrivacyConsentModalView.swift
//
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI

struct PrivacyConsentModalView: View {
    var body: some View {
        PrivacyConsentView()
        #if os(macOS)
            .frame(width: 360, height: 480)
        #endif
            .environmentObject(PrivacyConsentLoader())
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
    }
}

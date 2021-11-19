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
            .environmentObject(PrivacyConsentLoader())
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
    }
}

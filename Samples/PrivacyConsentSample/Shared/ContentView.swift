//
//  ContentView.swift
//  Shared
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI
@testable import PrivacyConsent

struct ContentView: View {
    var body: some View {
        PrivacyConsentView()
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
            .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
    }
}

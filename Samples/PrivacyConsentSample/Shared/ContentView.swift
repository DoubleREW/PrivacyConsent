//
//  ContentView.swift
//  Shared
//
//  Created by Fausto Ristagno on 17/11/21.
//

import SwiftUI
import PrivacyConsent

struct ContentView: View {
    @Environment(\.presentPrivacyConsentModal)
    private var presentPrivacyConsentModal

    var body: some View {
        VStack(alignment: .center) {
            Button("Mostra") {
                presentPrivacyConsentModal()
            }
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

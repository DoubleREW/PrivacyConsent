//
//  SwiftUIView.swift
//  
//
//  Created by Fausto Ristagno on 16/11/21.
//

import SwiftUI

struct ConsentView: View {
    @Binding var consent: Consent
    private var isEditable: Bool {
        return (consent.type.allowsUpdate || !consent.granted)
    }
    
    var body: some View {
        Section(footer: Text(consent.type.description)) {
            Toggle(consent.type.title, isOn: $consent.granted)
                .disabled(!isEditable)
        }
    }
}

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ConsentView(consent: .constant(Consent(type: .usageStats, status: .denied)))
            ConsentView(consent: .constant(Consent(type: .crashReports, status: .grant)))
            ConsentView(consent: .constant(Consent(type: .personalizedAds, status: .unknown)))
        }
    }
}

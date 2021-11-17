//
//  SwiftUIView.swift
//  
//
//  Created by Fausto Ristagno on 16/11/21.
//

import SwiftUI

struct ConsentView: View {
    var consent: Consent
    private var isEditable: Bool {
        return (consent.type.allowsUpdate || consent.status == .unknown)
    }
    
    var body: some View {
        Section(footer: Text(consent.type.description)) {
            Toggle(consent.type.title, isOn: consent.$flag)
                .disabled(!isEditable)
        }
        /*VStack(alignment: .leading) {
            Toggle(consent.type.title, isOn: consent.$flag)
                .disabled(!isEditable)
            Text(consent.type.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }*/
    }
}

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ConsentView(consent: Consent(type: .usageStats, status: .grant))
            ConsentView(consent: Consent(type: .crashReports, status: .denied))
            ConsentView(consent: Consent(type: .personalizedAds, status: .unknown))
        }
    }
}

//
//  PrivacyConsentView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI

public struct PrivacyConsentView : View {
    @EnvironmentObject var vm: PrivacyConsentViewModel

    public var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Image("PrivacyIcon", bundle: Bundle.module)
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 96, height: 96)
                    .padding()
                Text(vm.text)
                if let url = vm.privacyPolicyUrl {
                    #if !os(macOS)
                    NavigationLink(destination: BrowserView(url: url)) {
                        Text("Read more")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    #else
                    if #available(macOS 11.0, *) {
                        Link("Read more", destination: url)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    #endif
                }
                Spacer()
                Button("Accept") {
                    vm.acceptAndClose()
                }
                .buttonStyle(.primary)
                NavigationLink(destination: PrivacyChoicesView()) {
                    Text("Customize")
                }
                .buttonStyle(.secondary)
            }
            .padding()
            #if !os(macOS)
            .navigationBarHidden(false)
            .navigationBarTitle("Privacy Consent", displayMode: .inline)
            #endif
        }
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
    }
}

struct PrivacyConsentView_Previews : PreviewProvider {
    static var previews: some View {
        PrivacyConsentView()
            .environmentObject(PrivacyConsentLoader())
            .environmentObject(PrivacyConsentViewModel())
            .environmentObject(PrivacyChoicesViewModel())
    }
}

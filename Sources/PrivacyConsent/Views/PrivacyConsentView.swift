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
    @EnvironmentObject var choicesVm: PrivacyChoicesViewModel

    public var body: some View {
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
                    Text("Read more", bundle: .module)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                #else
                if #available(macOS 11.0, *) {
                    Link(String(localized: "Read more", bundle: .module), destination: url)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Button(String(localized: "Read more", bundle: .module)) {
                        vm.open(url)
                    }
                }
                #endif
            }
            Spacer()
            Button(String(localized: "Accept", bundle: .module)) {
                vm.acceptAndClose()
            }
            .buttonStyle(.primary)
            #if !os(macOS)
            NavigationLink(destination: PrivacyChoicesView()) {
                Text("Customize", bundle: .module)
            }
            .buttonStyle(.secondary)
            #else
            Button(String(localized: "Customize", bundle: .module)) {
                vm.customizeSheetVisible.toggle()
            }
            .buttonStyle(.secondary)
            #endif
        }
        .padding()
        #if !os(macOS)
        .navigationBarHidden(false)
        .navigationBarTitle(String(localized: "Privacy Consent", bundle: .module), displayMode: .inline)
        #endif
        .sheet(isPresented: $vm.customizeSheetVisible) {
            PrivacyChoicesView()
                // Fix crash due to a bug of macOS 10.15
                // should be removed when support to this OS will be dropped
                .environmentObject(self.choicesVm)
                .frame(width: 360, height: 480)
        }
    }
}

struct PrivacyConsentNavigationView : View {
    public var body: some View {
        NavigationView {
            PrivacyConsentView()
        }
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

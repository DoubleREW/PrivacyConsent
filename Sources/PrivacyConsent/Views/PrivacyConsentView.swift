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
            #if !os(macOS)
            NavigationLink(destination: PrivacyChoicesView()) {
                Text("Customize")
            }
            .buttonStyle(.secondary)
            #else
            Button("Customize") {
                vm.customizeSheetVisible.toggle()
            }
            .buttonStyle(.secondary)
            #endif
        }
        .padding()
        #if !os(macOS)
        .navigationBarHidden(false)
        .navigationBarTitle("Privacy Consent", displayMode: .inline)
        #endif
        .sheet(isPresented: $vm.customizeSheetVisible) {
            PrivacyChoicesView()
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

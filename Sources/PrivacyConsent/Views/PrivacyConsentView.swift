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
                    NavigationLink(destination: BrowserView(url: url)) {
                        Text("Read more")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            .navigationBarTitle("Title", displayMode: .inline)
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

//
//  PrivacyChoicesView.swift
//  
//
//  Created by Fausto Ristagno on 15/11/21.
//

import SwiftUI

struct PrivacyChoicesView: View {
    @EnvironmentObject var vm: PrivacyChoicesViewModel
    
    var body: some View {
        VStack {
            List(vm.consents) { consent in
                ConsentView(consent: consent)
            }
            Spacer()
            Button("Accept all") {
                
            }
            .buttonStyle(.primary)
            Button("Close") {
                
            }
            .buttonStyle(.secondary)
        }
    }
}

struct PrivacyChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyChoicesView()
            .environmentObject(PrivacyChoicesViewModel())
    }
}

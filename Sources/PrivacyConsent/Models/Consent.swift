//
//  Consent.swift
//  
//
//  Created by Fausto Ristagno on 16/11/21.
//

import Foundation
import SwiftUI

struct Consent {
    let type: ConsentType
    var status: ConsentStatus {
        didSet {
            self.flag = self.status.isGranted
        }
    }
    @State var flag: Bool {
        didSet {
            PrivacyConsentManager.default.setConsent(self.type, status: flag ? .grant : .denied)
        }
    }
    
    init(type: ConsentType, status: ConsentStatus) {
        self.type = type
        self.status = status
        self.flag = status.isGranted
    }
}

extension Consent : Identifiable {
    var id: String {
        return self.type.rawValue
    }
}

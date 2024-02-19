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
    var granted: Bool

    var status: ConsentStatus {
        granted ? .grant : .denied
    }

    init(type: ConsentType, status: ConsentStatus) {
        self.type = type
        self.granted = status.isGranted
    }
}

extension Consent : Identifiable {
    var id: String {
        return self.type.rawValue
    }
}

extension Consent : Hashable { }

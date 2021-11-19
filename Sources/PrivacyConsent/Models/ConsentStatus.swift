//
//  ConsentStatus.swift
//
//
//  Created by Fausto Ristagno on 16/11/21.
//

import Foundation

public enum ConsentStatus {
    case unknown, grant, denied

    var boolValue: Bool? {
        switch self {
        case .denied:
            return false
        case .grant:
            return true
        default:
            return nil
        }
    }

    public var isGranted: Bool {
        self == .grant
    }

    public static func from(bool: Bool?) -> ConsentStatus {
        guard let flag = bool else {
            return .unknown
        }

        return flag ? .grant : .denied
    }
}

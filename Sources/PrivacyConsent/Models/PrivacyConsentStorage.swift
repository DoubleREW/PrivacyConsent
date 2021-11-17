//
//  PrivacyConsentStorage.swift
//  
//
//  Created by Fausto Ristagno on 17/11/21.
//

import Foundation

public protocol PrivacyConsentStorage {
    @discardableResult
    func synchronize() -> Bool
    func dictionary(forKey defaultName: String) -> [String : Any]?
    func setValue(_ value: Any?, forKey key: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults : PrivacyConsentStorage {}

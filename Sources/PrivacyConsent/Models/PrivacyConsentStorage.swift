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

class InMemoryPrivacyConsentStorage : PrivacyConsentStorage {
    private var storage: [String: [String : Any]] = [:]

    init() {}

    func synchronize() -> Bool {
        return true
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return storage[defaultName]
    }
    
    func setValue(_ value: Any?, forKey key: String) {
        if let value = value as? [String: Any] {
            self.storage[key] = value
        } else {
            self.storage.removeValue(forKey: key)
        }
    }
    
    func removeObject(forKey defaultName: String) {
        self.storage.removeValue(forKey: defaultName)
    }
    

}

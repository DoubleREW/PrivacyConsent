//
//  PrivacyConsentManager.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//
import Foundation

public class PrivacyConsentManager {
    public static let `default` = PrivacyConsentManager()
    public static let consentDidChangeNotification = Notification.Name("PrivacyConsentHelperConsentDidChangeNotification")
    public static let consentsControllerWillPresent = Notification.Name("PrivacyConsentHelperConsentsControllerWillPresent")
    private static let storeKey = "PrivacyConsentFlags"
    public private(set) var supportedConsentTypes: [ConsentType]!
    
    fileprivate var userDefaults: UserDefaults = UserDefaults.standard
    
    public var privacyPolicyUrl: URL?
    
    public class func configure(supportedConsentTypes: [ConsentType], privacyPolicyUrl: URL?, userDefaults: UserDefaults = UserDefaults.standard) {
        Self.default.supportedConsentTypes = supportedConsentTypes
        Self.default.userDefaults = userDefaults
        Self.default.privacyPolicyUrl = privacyPolicyUrl
    }
    
    public func shouldShowConsentsController() -> Bool {
        for consent in self.supportedConsentTypes {
            if self.consentStatus(for: consent) == .unknown {
                return true
            }
        }
        
        return false
    }
    
    public func presentConsentsController(ifNeeded: Bool = true, allowsClose: Bool = false) {
        guard ifNeeded == false || self.shouldShowConsentsController() else {
            return
        }
        // TODO: Sostituire con View SwiftUI
        /*
        let storyboard = UIStoryboard(name: "PrivacyConsent", bundle: Bundle(for: Self.self))
        guard
            let controller = storyboard.instantiateInitialViewController(),
            let rootVC = UIApplication.shared.rootViewController
        else {
            fatalError("Missing initial view controller in privacy consent storyboard")
        }
        
        controller.modalPresentationStyle = .formSheet
        
        if #available(iOS 13.0, *) {
            controller.isModalInPresentation = !allowsClose
        }
        
        rootVC.present(controller, animated: true)
        */
        
        NotificationCenter.default.post(
            name: Self.consentsControllerWillPresent,
            object: self,
            userInfo: nil)
    }
    
    public func setConsent(_ consent: ConsentType, status: ConsentStatus) {
        guard status != self.consentStatus(for: consent) else {
            return
        }
        
        var consents: [String: Bool] = (self.userDefaults.dictionary(forKey: Self.storeKey) as? [String: Bool]) ?? [:]
        
        consents[consent.rawValue] = status.boolValue
        
        self.userDefaults.setValue(consents, forKey: Self.storeKey)
        self.userDefaults.synchronize()
        self.onConsentDidChange(consent: consent)
    }
    
    public func consentStatus(for consent: ConsentType) -> ConsentStatus {
        guard let consents = self.userDefaults.dictionary(forKey: Self.storeKey) else {
            return .unknown
        }
        
        guard let received = consents[consent.rawValue] as? Bool else {
            return .unknown
        }
        
        return ConsentStatus.from(bool: received)
    }
    
    /// Acconsente a tutti tipi senza valore o che permettono l'aggiornamento
    public func consentAll() {
        for consent in self.supportedConsentTypes.filter({ $0.allowsUpdate || self.consentStatus(for: $0) == .unknown }) {
            self.setConsent(consent, status: .grant)
        }
    }
    
    /// Nega a tutti tipi senza valore o che permettono l'aggiornamento
    public func denyAll() {
        for consent in self.supportedConsentTypes.filter({ $0.allowsUpdate || self.consentStatus(for: $0) == .unknown }) {
            self.setConsent(consent, status: .denied)
        }
    }
    
    /// Applica il valore predefinito a tutti tipi non valorizzati
    public func denyNotGranted() {
        for consent in self.supportedConsentTypes.filter({ self.consentStatus(for: $0) == .unknown }) {
            self.setConsent(consent, status: .denied)
        }
    }
    
    public func resetConsents() {
        self.userDefaults.removeObject(forKey: Self.storeKey)
        self.userDefaults.synchronize()
        self.onConsentDidChange(consent: nil)
    }
    
    fileprivate func onConsentDidChange(consent: ConsentType?) {
        var userInfo = [String: Any]()
        
        if consent != nil {
            userInfo["consent"] = consent!
        }
        
        NotificationCenter.default.post(
            name: Self.consentDidChangeNotification,
            object: self,
            userInfo: userInfo)
    }
}

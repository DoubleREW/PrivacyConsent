//
//  PrivacyConsentManager.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//
import Foundation
import SwiftUI

@Observable
public class PrivacyConsentManager {
    private static let storeKey = "PrivacyConsentFlags"
    private static let defaultIntroText = String(localized: """
This app collects anonymous data about usage and crash reports, these data help to fix bugs quickly and make the app grow update after update.
Tap Accept if you want to allow the app to collect anonymous info, or tap Customize if you want to choose which info share with the developer.
""", bundle: .module)

    public private(set) var isConfigured: Bool = false
    public private(set) var hasMissingConsents: Bool = false
    public private(set) var supportedConsentTypes: [ConsentType] = []
    public var privacyPolicyUrl: URL? = nil
    fileprivate var storage: any PrivacyConsentStorage = UserDefaults.standard
    public var introText = PrivacyConsentManager.defaultIntroText

    public func configure(
        supportedConsentTypes: [ConsentType],
        privacyPolicyUrl: URL? = nil,
        storage: any PrivacyConsentStorage = UserDefaults.standard,
        introText: String? = nil
    ) {
        self.supportedConsentTypes = supportedConsentTypes
        self.storage = storage
        self.privacyPolicyUrl = privacyPolicyUrl
        self.introText = introText == nil ? PrivacyConsentManager.defaultIntroText : introText!

        refreshMissingConsents()
        
        self.isConfigured = true
    }

    public init() { }

    public func setConsent(_ consent: ConsentType, status: ConsentStatus) {
        guard status != self.consentStatus(for: consent) else {
            return
        }

        var consents: [String: Bool] = (self.storage.dictionary(forKey: Self.storeKey) as? [String: Bool]) ?? [:]

        consents[consent.rawValue] = status.boolValue

        self.storage.setValue(consents, forKey: Self.storeKey)
        self.storage.synchronize()
        self.onConsentDidChange(consent: consent)
    }

    public func consentStatus(for consent: ConsentType) -> ConsentStatus {
        guard let consents = self.storage.dictionary(forKey: Self.storeKey) else {
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
        self.storage.removeObject(forKey: Self.storeKey)
        self.storage.synchronize()
        self.onConsentDidChange(consent: nil)
    }

    private func checkShouldShowConsentModal() -> Bool {
        for consent in self.supportedConsentTypes {
            if self.consentStatus(for: consent) == .unknown {
                return true
            }
        }

        return false
    }

    internal func setStorage(_ storage: some PrivacyConsentStorage) {
        self.storage = storage
    }

    private func refreshMissingConsents() {
        self.hasMissingConsents = checkShouldShowConsentModal()
    }

    private func onConsentDidChange(consent: ConsentType?) {
        var userInfo = [String: Any]()

        if consent != nil {
            userInfo["consent"] = consent!
        }

        refreshMissingConsents()

        NotificationCenter.default.post(
            name: .privacyConsentDidChange,
            object: self,
            userInfo: userInfo)
    }
}

public extension Notification.Name {
    static let privacyConsentDidChange = Notification.Name("PrivacyConsentManagerConsentDidChangeNotification")

}

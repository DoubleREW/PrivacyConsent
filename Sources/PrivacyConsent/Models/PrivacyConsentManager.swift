//
//  PrivacyConsentManager.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//
import Foundation
import SwiftUI
#if !os(macOS)
import UIKit
#endif

public class PrivacyConsentManager {
    public static let `default` = PrivacyConsentManager()
    public static let consentDidChangeNotification = Notification.Name("PrivacyConsentHelperConsentDidChangeNotification")
    public static let consentsControllerWillPresent = Notification.Name("PrivacyConsentHelperConsentsControllerWillPresent")
    public static let consentsControllerDidDismiss = Notification.Name("PrivacyConsentHelperConsentsControllerDidDismiss")
    private static let storeKey = "PrivacyConsentFlags"
    public private(set) var supportedConsentTypes: [ConsentType]!
    private weak var consentsViewController: AnyObject?

    fileprivate var storage: PrivacyConsentStorage = UserDefaults.standard

    public var privacyPolicyUrl: URL?

    public class func configure(supportedConsentTypes: [ConsentType], privacyPolicyUrl: URL?, storage: PrivacyConsentStorage = UserDefaults.standard) {
        Self.default.supportedConsentTypes = supportedConsentTypes
        Self.default.storage = storage
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
        guard self.consentsViewController == nil else {
            return
        }

        guard ifNeeded == false || self.shouldShowConsentsController() else {
            return
        }

        #if !os(macOS)
        guard let rootVC = UIApplication.shared.rootViewController else {
            fatalError("Missing root view controller")
        }

        let controller = UIHostingController(rootView: PrivacyConsentModalView())
        controller.modalPresentationStyle = .formSheet
        controller.isModalInPresentation = !allowsClose

        rootVC.present(controller, animated: true)

        self.consentsViewController = controller
        #else
        let controller = NSHostingController(rootView: PrivacyConsentModalView())
        let privacyWindow = NSWindow(contentViewController: controller)
        NSApp.mainWindow?.beginSheet(privacyWindow, completionHandler: { response in
            self.consentsViewController = nil
        })
        self.consentsViewController = privacyWindow
        #endif

        NotificationCenter.default.post(
            name: Self.consentsControllerWillPresent,
            object: self,
            userInfo: nil)
    }

    public func dismissConsentsCrontroller() {
        defer {
            self.consentsViewController = nil
        }

        #if !os(macOS)
        guard let controller = self.consentsViewController as? UIViewController else {
            return
        }

        controller.dismiss(animated: true) {
            NotificationCenter.default.post(
                name: Self.consentsControllerDidDismiss,
                object: self,
                userInfo: nil)
        }
        #else
        guard let privacyWindow = self.consentsViewController as? NSWindow else {
            return
        }

        NSApp.mainWindow?.endSheet(privacyWindow)

        NotificationCenter.default.post(
            name: Self.consentsControllerDidDismiss,
            object: self,
            userInfo: nil)
        #endif
    }

    func setConsent(_ consent: ConsentType, status: ConsentStatus) {
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

#if !os(macOS)
extension UIApplication {
    var mainWindow: UIWindow? {
        return self.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }

    var rootViewController: UIViewController? {
        return self.mainWindow?.rootViewController
    }
}
#endif

//
//  ConsentModalPresenter.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

import Foundation

public protocol ConsentModalPresenter {
    var consentManager: PrivacyConsentManager { get }
    var shouldPresent: Bool { get }

    init(consentManager: PrivacyConsentManager)

    func present(ifNeeded: Bool, allowsClose: Bool)
    func dismiss()
}

public extension ConsentModalPresenter {
    var shouldPresent: Bool {
        consentManager.hasMissingConsents
    }
}

extension Notification.Name {
    public static let privacyConsentModalWillPresent = Notification.Name("PrivacyConsentModalWillPresent")
    public static let privacyConsentModalDidDismiss = Notification.Name("PrivacyConsentModalDidDismiss")
}

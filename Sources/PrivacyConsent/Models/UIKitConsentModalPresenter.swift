//
//  UIKitConsentModalPresenter.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public class UIKitConsentModalPresenter : ConsentModalPresenter {
    public let consentManager: PrivacyConsentManager
    private weak var consentsViewController: UIViewController?

    public required init(consentManager: PrivacyConsentManager) {
        self.consentManager = consentManager
    }

    private var foregroundWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first
    }

    private var rootViewController: UIViewController? {
        return self.foregroundWindow?.rootViewController
    }

    public func present(ifNeeded: Bool, allowsClose: Bool) {
        guard self.consentsViewController == nil else {
            return
        }

        guard ifNeeded == false || self.shouldPresent else {
            return
        }

        guard let rootVC = self.rootViewController else {
            fatalError("Missing root view controller")
        }

        let controller = UIHostingController(rootView: PrivacyConsentView())
        controller.modalPresentationStyle = .formSheet
        controller.isModalInPresentation = !allowsClose

        rootVC.present(controller, animated: true)

        self.consentsViewController = controller

        NotificationCenter.default.post(
            name: .privacyConsentModalWillPresent,
            object: self,
            userInfo: nil)
    }
    
    public func dismiss() {
        defer {
            self.consentsViewController = nil
        }

        guard let controller = self.consentsViewController else {
            return
        }

        controller.dismiss(animated: true) {
            NotificationCenter.default.post(
                name: .privacyConsentModalDidDismiss,
                object: self,
                userInfo: nil)
        }
    }
}
#endif

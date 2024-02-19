//
//  AppKitConsentModalPresenter.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

#if canImport(AppKit)
import SwiftUI
import AppKit

public class AppKitConsentModalPresenter : ConsentModalPresenter {
    public let consentManager: PrivacyConsentManager
    private weak var consentsWindow: NSWindow?

    public required init(consentManager: PrivacyConsentManager) {
        self.consentManager = consentManager
    }
    
    public func present(ifNeeded: Bool, allowsClose: Bool) {
        guard self.consentsWindow == nil else {
            return
        }

        guard ifNeeded == false || self.shouldPresent else {
            return
        }

        let controller = NSHostingController(rootView: PrivacyConsentView())
        let privacyWindow = NSWindow(contentViewController: controller)
        privacyWindow.title = String(localized: "Privacy Consent", bundle: .module)

        if allowsClose {
            privacyWindow.makeKeyAndOrderFront(nil)
        } else {
            NSApp.mainWindow?.beginSheet(privacyWindow, completionHandler: { response in
                self.consentsWindow = nil
            })
        }

        self.consentsWindow = privacyWindow

        NotificationCenter.default.post(
            name: .privacyConsentModalWillPresent,
            object: self,
            userInfo: nil)
    }
    
    public func dismiss() {
        guard let privacyWindow = self.consentsWindow else {
            return
        }

        privacyWindow.sheets.forEach { sheet in
            privacyWindow.endSheet(sheet)
        }

        if privacyWindow.parent == nil {
            privacyWindow.close()
        } else {
            NSApp.mainWindow?.endSheet(privacyWindow)
        }

        NotificationCenter.default.post(
            name: .privacyConsentModalDidDismiss,
            object: self,
            userInfo: nil)
    }
}
#endif

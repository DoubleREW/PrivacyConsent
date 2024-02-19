//
//  AppKitConsentModalPresenter.swift
//
//
//  Created by Fausto Ristagno on 18/02/24.
//

#if canImport(AppKit)
import SwiftUI
import AppKit

fileprivate final class ConsentModalSheet<Content: View>: NSWindow {

    init(rootView: Content) {
        super.init(contentRect: .zero, styleMask: [.titled, .closable, .docModalWindow], backing: .buffered, defer: false)
        self.contentView = NSHostingView(rootView: rootView)
    }

    override func performClose(_ sender: Any?) {
        guard let sheetParent else {
            super.performClose(sender)
            return
        }
        sheetParent.endSheet(self, returnCode: .alertFirstButtonReturn)
    }

}


public class AppKitConsentModalPresenter : ConsentModalPresenter {
    public let consentManager: PrivacyConsentManager
    private var consentsWindow: NSWindow?

    public required init(consentManager: PrivacyConsentManager) {
        self.consentManager = consentManager
        NotificationCenter.default.addObserver(self, selector: #selector(onWindowWillClose), name: NSWindow.willCloseNotification, object: nil)
    }
    
    public func present(ifNeeded: Bool, allowsClose: Bool) {
        guard self.consentsWindow == nil else {
            return
        }

        guard ifNeeded == false || self.shouldPresent else {
            return
        }


        let rootView = PrivacyConsentView()
            .environment(consentManager)

        let privacyWindow: NSWindow
        if allowsClose {
            privacyWindow = NSWindow(contentViewController:
                                        NSHostingController(rootView: rootView))
        } else {
            privacyWindow = ConsentModalSheet(rootView: rootView)
        }
        
        var windowFrame = privacyWindow.frame
        windowFrame.size = NSSize(width: 320, height: 480)
        privacyWindow.setFrame(windowFrame, display: true, animate: false)
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

    @objc private func onWindowWillClose(_ notification: Notification) {
        if notification.object as? NSWindow == self.consentsWindow {
            self.consentsWindow = nil
        }
    }
}
#endif

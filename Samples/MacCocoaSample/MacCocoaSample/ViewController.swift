//
//  ViewController.swift
//  MacCocoaSample
//
//  Created by Fausto Ristagno on 14/12/21.
//

import Cocoa
import PrivacyConsent

class ViewController: NSViewController {

    private let consentManager = PrivacyConsentManager()
    private var consentModalPresenter: AppKitConsentModalPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        consentManager.configure(
            supportedConsentTypes: [
                .crashReports,
                .usageStats
            ],
            privacyPolicyUrl: URL(string: "https://google.com")!)
        consentModalPresenter = AppKitConsentModalPresenter(consentManager: consentManager)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func showClosable(_ sender: Any?) {
        consentModalPresenter.present(ifNeeded: false, allowsClose: true)
    }

    @IBAction func show(_ sender: Any?) {
        consentModalPresenter.present(ifNeeded: false, allowsClose: false)
    }
}


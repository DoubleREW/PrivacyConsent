//
//  ViewController.swift
//  MacCocoaSample
//
//  Created by Fausto Ristagno on 14/12/21.
//

import Cocoa
import PrivacyConsent

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        PrivacyConsentManager.configure(
            supportedConsentTypes: [
                .crashReports,
                .usageStats,
                .personalizedAds
            ],
            privacyPolicyUrl: URL(string: "https://google.com")!)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func showClosable(_ sender: Any?) {
        PrivacyConsentManager.default.presentConsentsController(
            ifNeeded: false, allowsClose: true)
    }

    @IBAction func show(_ sender: Any?) {
        PrivacyConsentManager.default.presentConsentsController(
            ifNeeded: false, allowsClose: false)
    }
}


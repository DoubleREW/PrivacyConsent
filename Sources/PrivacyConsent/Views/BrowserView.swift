//
//  BrowserView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI
import SafariServices

struct BrowserView : UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<BrowserView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<BrowserView>) {

    }
}

struct BrowserView_Previews : PreviewProvider {
    static var previews: some View {
        BrowserView(url: URL(string: "https://google.com")!)
    }
}

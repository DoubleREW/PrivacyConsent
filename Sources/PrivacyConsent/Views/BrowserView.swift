//
//  BrowserView.swift
//
//
//  Created by Fausto Ristagno on 15/11/21.
//

import Foundation
import SwiftUI
#if !os(macOS)
import SafariServices
#endif

#if !os(macOS)
struct BrowserView : UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<BrowserView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<BrowserView>) {

    }
}
#else
struct BrowserView : View {
    let url: URL

    var body: some View {
        Text("Missing")
    }
}
#endif

struct BrowserView_Previews : PreviewProvider {
    static var previews: some View {
        BrowserView(url: URL(string: "https://google.com")!)
    }
}

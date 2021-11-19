//
//  PrimaryButton.swift
//
//
//  Created by Fausto Ristagno on 16/11/21.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Primary Button") {

        }
        .buttonStyle(.primary)
    }
}

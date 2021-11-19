//
//  SecondaryButtonStyle.swift
//
//
//  Created by Fausto Ristagno on 16/11/21.
//

import Foundation
import SwiftUI

struct SecondaryButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}

struct SecondaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Secondary Button") {

        }
        .buttonStyle(.secondary)
    }
}

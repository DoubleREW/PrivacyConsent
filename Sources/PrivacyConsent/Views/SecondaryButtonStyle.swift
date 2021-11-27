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
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.accentColor)
            .background(Color.white.opacity(0.01))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accentColor, lineWidth: 1)
                    .padding([.leading, .trailing], 1)
            )
            .opacity(configuration.isPressed ? 0.75 : 1.0)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}

struct SecondaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button("Secondary Button") {

            }
            .buttonStyle(.secondary)
        }.padding()
    }
}

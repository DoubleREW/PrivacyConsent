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
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 16.0)
                    .fill(Color.accentColor)
            )
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button("Secondary Button") {

            }
            .buttonStyle(.primary)
        }.padding()
    }
}

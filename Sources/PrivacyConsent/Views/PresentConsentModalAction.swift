//
//  PresentConsentModalAction.swift
//
//
//  Created by Fausto Ristagno on 19/02/24.
//

import SwiftUI

public struct PresentConsentModalAction {
    private let handler: () -> Void

    public init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    public func callAsFunction() {
        handler()
    }
}

private struct PresentConsentModalActionEnvironmentKey: EnvironmentKey {
    static let defaultValue: PresentConsentModalAction = .init({ })
}

public extension EnvironmentValues {
    internal(set) var presentPrivacyConsentModal: PresentConsentModalAction {
        get { self[PresentConsentModalActionEnvironmentKey.self] }
        set { self[PresentConsentModalActionEnvironmentKey.self] = newValue }
    }
}

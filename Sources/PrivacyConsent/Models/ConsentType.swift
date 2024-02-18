//
//  ConsentType.swift
//
//
//  Created by Fausto Ristagno on 16/11/21.
//

import Foundation

public struct ConsentType {
    public let rawValue: String
    public let title: String
    public let description: String
    public let allowsUpdate: Bool

    public static let usageStats: ConsentType = ConsentType(
        rawValue: "usageStats",
        title: String(localized: "Anonymous usage statistics", bundle: .module),
        description: String(localized: "Allow to collect statistics about how the app is used, for example to know which tool is most used.", bundle: .module),
        allowsUpdate: true)
    public static let crashReports: ConsentType = ConsentType(
        rawValue: "crashReports",
        title: String(localized: "Anonymous crash reports", bundle: .module),
        description: String(localized: "Allow to send anonymous crash reports, this is useful to quickly fix bugs.", bundle: .module),
        allowsUpdate: true)
    public static let personalizedAds: ConsentType = ConsentType(
        rawValue: "personalizedAds",
        title: String(localized: "Personalized ads", bundle: .module),
        description: String(localized: "Allow to deliver personalized ads to you. You can change this choice from the iOS settings.", bundle: .module),
        allowsUpdate: false)
}

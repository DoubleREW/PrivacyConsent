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
        title: "Anonymous usage statistics",
        description: "Allow to collect statistics about how the app is used, for example to know which tool is most used.",
        allowsUpdate: true)
    public static let crashReports: ConsentType = ConsentType(
        rawValue: "crashReports",
        title: "Anonymous crash reports",
        description: "Allow to send anonymous crash reports, this is useful to quickly fix bugs.",
        allowsUpdate: true)
    public static let personalizedAds: ConsentType = ConsentType(
        rawValue: "personalizedAds",
        title: "Personalized ads",
        description: "Allow to deliver personalized ads to you. You can change this choice from the iOS settings.",
        allowsUpdate: false)
}

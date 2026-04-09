//
//  GuildExternalLink.swift
//  116GuildMate
//

import Foundation

enum GuildExternalLink: String, CaseIterable {
    case privacyPolicy = "https://www.termsfeed.com/live/c55f5af7-44b8-4132-a1f7-0af4c1d2aa61"
    case termsOfUse = "https://www.termsfeed.com/live/8d61ca10-31ad-418d-9784-e8bdf3124824"

    var url: URL? {
        URL(string: rawValue)
    }
}

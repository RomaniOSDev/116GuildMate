//
//  PersistenceManager.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import Foundation

final class GuildFlowDefaultsStore {
    static let nucleus = GuildFlowDefaultsStore()

    private let rememberedLandingKey = "LastUrl"
    private let nativeHubPresentedKey = "HasShownContentView"
    private let browseSessionOkKey = "HasSuccessfulWebViewLoad"

    var rememberedLandingAddress: String? {
        get {
            if let url = LinkSlotCache.pinnedAbsoluteLink {
                return url.absoluteString
            }
            return UserDefaults.standard.string(forKey: rememberedLandingKey)
        }
        set {
            if let urlString = newValue {
                UserDefaults.standard.set(urlString, forKey: rememberedLandingKey)
                if let url = URL(string: urlString) {
                    LinkSlotCache.pinnedAbsoluteLink = url
                }
            } else {
                UserDefaults.standard.removeObject(forKey: rememberedLandingKey)
                LinkSlotCache.pinnedAbsoluteLink = nil
            }
        }
    }

    var hasPresentedNativeHub: Bool {
        get {
            UserDefaults.standard.bool(forKey: nativeHubPresentedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nativeHubPresentedKey)
        }
    }

    var hasSuccessfulBrowseSession: Bool {
        get {
            UserDefaults.standard.bool(forKey: browseSessionOkKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: browseSessionOkKey)
        }
    }

    private init() {}
}

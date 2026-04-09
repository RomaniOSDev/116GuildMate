//
//  MemberClass.swift
//  116GuildMate
//

import Foundation

enum MemberClass: String, CaseIterable, Codable {
    case warrior = "Warrior"
    case paladin = "Paladin"
    case hunter = "Hunter"
    case rogue = "Rogue"
    case priest = "Priest"
    case mage = "Mage"
    case warlock = "Warlock"
    case druid = "Druid"
    case shaman = "Shaman"
    case deathKnight = "Death Knight"
    case demonHunter = "Demon Hunter"
    case monk = "Monk"

    var icon: String {
        switch self {
        case .warrior: return "shield.fill"
        case .paladin: return "cross.fill"
        case .hunter: return "arrow.right.circle.fill"
        case .rogue: return "eye.slash.fill"
        case .priest: return "wand.and.stars"
        case .mage: return "bolt.fill"
        case .warlock: return "flame.fill"
        case .druid: return "leaf.fill"
        case .shaman: return "tornado"
        case .deathKnight: return "moon.stars.fill"
        case .demonHunter: return "eye.fill"
        case .monk: return "figure.martial.arts"
        }
    }
}

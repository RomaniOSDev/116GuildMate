//
//  MemberRole.swift
//  116GuildMate
//

import Foundation

enum MemberRole: String, CaseIterable, Codable {
    case master = "Guild Master"
    case officer = "Officer"
    case veteran = "Veteran"
    case member = "Member"
    case recruit = "Recruit"
    case alt = "Alt"

    var icon: String {
        switch self {
        case .master: return "crown.fill"
        case .officer: return "star.fill"
        case .veteran: return "shield.fill"
        case .member: return "person.fill"
        case .recruit: return "leaf.fill"
        case .alt: return "arrow.triangle.2.circlepath"
        }
    }

    var priority: Int {
        switch self {
        case .master: return 1
        case .officer: return 2
        case .veteran: return 3
        case .member: return 4
        case .recruit: return 5
        case .alt: return 6
        }
    }
}

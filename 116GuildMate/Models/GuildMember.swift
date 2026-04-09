//
//  GuildMember.swift
//  116GuildMate
//

import Foundation

struct GuildMember: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var level: Int
    var class_: MemberClass
    var role: MemberRole
    var professions: [Profession]
    var mainCharacterId: UUID?
    var mainCharacterName: String?
    var joinedDate: Date
    var lastOnline: Date?
    var notes: String?
    var isActive: Bool
    var raidAttendance: Double
    var discordTag: String?
    var createdAt: Date
}

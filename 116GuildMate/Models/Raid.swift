//
//  Raid.swift
//  116GuildMate
//

import Foundation

struct Raid: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var date: Date
    var duration: Int
    var bossNames: [String]
    var participants: [UUID]
    var loot: [RaidLoot]
    var notes: String?
    var isCompleted: Bool
    let createdAt: Date
}

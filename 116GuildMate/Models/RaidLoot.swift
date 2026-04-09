//
//  RaidLoot.swift
//  116GuildMate
//

import Foundation

struct RaidLoot: Identifiable, Codable, Hashable {
    let id: UUID
    var itemName: String
    var recipientId: UUID
    var recipientName: String
    var isBound: Bool
}

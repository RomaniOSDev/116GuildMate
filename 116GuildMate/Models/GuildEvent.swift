//
//  GuildEvent.swift
//  116GuildMate
//

import Foundation

struct GuildEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var date: Date
    var type: String
    var description: String
    var participants: [UUID]
    var notes: String?
    let createdAt: Date
}

//
//  GuildStat.swift
//  116GuildMate
//

import Foundation

struct GuildStat: Codable {
    var totalMembers: Int
    var activeMembers: Int
    var averageLevel: Double
    var totalRaids: Int
    var totalLoot: Int
    var guildLevel: Int
    var guildExperience: Int
}

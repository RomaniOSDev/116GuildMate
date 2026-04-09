//
//  GuildResource.swift
//  116GuildMate
//

import Foundation

struct GuildResource: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var quantity: Int
    var donatedBy: [ResourceDonation]
    var notes: String?
}

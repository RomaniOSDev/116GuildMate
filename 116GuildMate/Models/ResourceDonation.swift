//
//  ResourceDonation.swift
//  116GuildMate
//

import Foundation

struct ResourceDonation: Identifiable, Codable, Hashable {
    let id: UUID
    var memberId: UUID
    var memberName: String
    var quantity: Int
    var date: Date
}

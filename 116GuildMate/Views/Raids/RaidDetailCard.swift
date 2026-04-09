//
//  RaidDetailCard.swift
//  116GuildMate
//

import SwiftUI

struct RaidDetailCard: View {
    let raid: Raid

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(GuildGradients.deepAccent)
                .frame(height: 5)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.guildActive.opacity(0.35), radius: 6, x: 0, y: 2)

            HStack {
                Text(raid.name)
                    .font(.headline)
                    .foregroundColor(.guildDark)
                Spacer()
                if raid.isCompleted {
                    Text("Cleared")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .fill(GuildGradients.chipSelected)
                        )
                        .shadow(color: Color.guildActive.opacity(0.32), radius: 6, x: 0, y: 3)
                }
            }
            HStack {
                Label(formattedDate(raid.date), systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Label("\(raid.duration) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            if !raid.bossNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(raid.bossNames, id: \.self) { boss in
                            Text(boss)
                                .font(.caption2.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(GuildGradients.badge)
                                )
                                .foregroundColor(.guildActive)
                        }
                    }
                }
            }
            HStack {
                Label("\(raid.participants.count) participants", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.guildActive)
                Spacer()
                if !raid.loot.isEmpty {
                    Label("\(raid.loot.count) items", systemImage: "gift.fill")
                        .font(.caption)
                        .foregroundColor(.guildActive)
                }
            }
        }
        .padding(16)
        .guildCard(cornerRadius: 18)
    }
}

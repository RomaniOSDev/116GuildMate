//
//  MemberCard.swift
//  116GuildMate
//

import SwiftUI

struct MemberCard: View {
    let member: GuildMember

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(GuildGradients.badge)
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.guildActive.opacity(0.65),
                                Color.white.opacity(0.35),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                Text(member.name.prefix(1).uppercased())
                    .foregroundColor(.guildActive)
                    .font(.title2)
                    .bold()
            }
            .frame(width: 54, height: 54)
            .shadow(color: Color.guildActive.opacity(0.22), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(member.name)
                        .foregroundColor(.guildDark)
                        .font(.headline)
                    Image(systemName: member.role.icon)
                        .foregroundColor(.guildActive)
                        .font(.caption)
                    if member.isActive {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.guildActive, Color.guildActive.opacity(0.6)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 6
                                )
                            )
                            .frame(width: 9, height: 9)
                            .shadow(color: Color.guildActive.opacity(0.5), radius: 3, x: 0, y: 1)
                    }
                }
                Text("\(member.class_.rawValue), level \(member.level)")
                    .font(.caption)
                    .foregroundColor(.gray)
                if let lastOnline = member.lastOnline {
                    Text("Last online: \(formattedShortDate(lastOnline))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("Attendance")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(String(format: "%.0f%%", member.raidAttendance))
                    .font(.headline)
                    .foregroundColor(.guildActive)
                    .shadow(color: Color.guildActive.opacity(0.25), radius: 4, x: 0, y: 2)
            }
        }
        .padding(16)
        .guildCard(cornerRadius: 18)
    }
}

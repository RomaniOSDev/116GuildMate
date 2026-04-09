//
//  StatCard.swift
//  116GuildMate
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.28), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: color.opacity(0.2), radius: 6, x: 0, y: 3)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18, weight: .semibold))
            }
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
            Text(value)
                .foregroundColor(.guildDark)
                .font(.title2)
                .bold()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .guildCard(cornerRadius: 16)
    }
}

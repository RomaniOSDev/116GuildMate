//
//  HomeComponents.swift
//  116GuildMate
//

import SwiftUI

// MARK: - Stat tile

struct HomeStatTile: View {
    let title: String
    let value: String
    let icon: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.32), accent.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: accent.opacity(0.28), radius: 8, x: 0, y: 4)
                Image(systemName: icon)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundColor(accent)
            }
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.guildDark)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundColor(Color.gray)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .guildCard(cornerRadius: 18)
    }
}

// MARK: - Section header

struct HomeSectionHeader: View {
    let title: String
    let icon: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(GuildGradients.badge)
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.guildActive)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.guildDark)
            }
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.guildActive)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(GuildGradients.badge)
                    )
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Quick action

struct HomeQuickAction: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(GuildGradients.cardElevated)
                        .frame(width: 60, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.9), Color.guildActive.opacity(0.35)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .guildSoftShadow()
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.guildActive)
                }
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.guildDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 78)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Event card (home)

struct HomeEventCard: View {
    let event: GuildEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(event.name)
                .font(.headline)
                .foregroundColor(.guildDark)
                .lineLimit(2)
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.caption2)
                    .foregroundColor(.guildActive.opacity(0.9))
                Text(formattedDateTime(event.date))
                    .font(.caption)
                    .foregroundColor(.guildActive)
            }
            Text(event.type)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(.white)
                .background(
                    Capsule()
                        .fill(GuildGradients.chipSelected)
                )
                .shadow(color: Color.guildActive.opacity(0.28), radius: 6, x: 0, y: 3)
            Spacer(minLength: 0)
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.9))
                Text("\(event.participants.count) participants")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
        .frame(width: 196, height: 160, alignment: .topLeading)
        .guildCard(cornerRadius: 20)
    }
}

// MARK: - Raid row (home)

struct HomeRaidRow: View {
    let raid: Raid

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(GuildGradients.badge)
                    .frame(width: 52, height: 52)
                Image(systemName: raid.isCompleted ? "checkmark.seal.fill" : "flag.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.guildActive)
            }
            .shadow(color: Color.guildActive.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(raid.name)
                        .font(.headline)
                        .foregroundColor(.guildDark)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gray.opacity(0.6))
                }
                HStack(spacing: 14) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(formattedDate(raid.date))
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(raid.duration) min")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
                if !raid.bossNames.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(raid.bossNames, id: \.self) { boss in
                                Text(boss)
                                    .font(.caption2.weight(.medium))
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(GuildGradients.badge)
                                    )
                                    .foregroundColor(.guildActive)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .guildCard(cornerRadius: 20)
    }
}

// MARK: - Empty state

struct HomeEmptyState: View {
    let icon: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(GuildGradients.badge)
                    .frame(width: 72, height: 72)
                    .shadow(color: Color.guildActive.opacity(0.18), radius: 12, x: 0, y: 6)
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.guildActive)
            }
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(actionTitle, action: action)
                .font(.subheadline.weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(GuildGradients.chipSelected)
                )
                .shadow(color: Color.guildActive.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 18)
        .guildCard(cornerRadius: 22)
    }
}

// MARK: - Tab shortcut

struct HomeTabShortcut: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.guildActive)
                Text(title)
                    .font(.caption.weight(.bold))
            }
            .foregroundColor(.guildDark)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(GuildGradients.cardElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.95), Color.guildActive.opacity(0.32)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .guildSoftShadow()
        }
        .buttonStyle(.plain)
    }
}

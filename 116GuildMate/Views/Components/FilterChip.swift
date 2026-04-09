//
//  FilterChip.swift
//  116GuildMate
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundColor(isSelected ? .white : color)
                .background { chipBackground }
                .overlay(chipBorder)
                .shadow(
                    color: isSelected ? color.opacity(0.38) : Color.black.opacity(0.06),
                    radius: isSelected ? 10 : 4,
                    x: 0,
                    y: isSelected ? 5 : 2
                )
                .shadow(
                    color: isSelected ? Color.clear : Color.guildDark.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GuildGradients.chipSelected)
        } else {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GuildGradients.cardElevated)
        }
    }

    private var chipBorder: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: isSelected
                        ? [Color.white.opacity(0.45), Color.white.opacity(0.1)]
                        : [color.opacity(0.38), Color.white.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}

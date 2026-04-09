//
//  GuildDesignSystem.swift
//  116GuildMate
//

import SwiftUI

// MARK: - Gradients

enum GuildGradients {
    /// Full screen backdrop
    static let screen = LinearGradient(
        colors: [
            Color.guildBackground,
            Color.white,
            Color.guildActive.opacity(0.09),
            Color(red: 0.94, green: 0.96, blue: 0.99),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Raised cards (members, raids, resources)
    static let cardElevated = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color.guildActive.opacity(0.06),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Hero / featured surfaces
    static let hero = LinearGradient(
        colors: [
            Color.white,
            Color.guildActive.opacity(0.12),
            Color.white.opacity(0.92),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Statistics / deep sections (headers, accents)
    static let deepAccent = LinearGradient(
        colors: [
            Color.guildDark.opacity(0.92),
            Color.guildActive.opacity(0.55),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Selected chips / primary buttons
    static let chipSelected = LinearGradient(
        colors: [
            Color.guildActive,
            Color(red: 0.22, green: 0.48, blue: 0.78),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Icon badges, inset pills
    static let badge = LinearGradient(
        colors: [
            Color.guildActive.opacity(0.22),
            Color.guildActive.opacity(0.08),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Soft panel for search fields
    static let insetField = LinearGradient(
        colors: [
            Color.white.opacity(0.95),
            Color.guildBackground.opacity(0.85),
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Floating action button
    static let fab = LinearGradient(
        colors: [
            Color.guildActive,
            Color(red: 0.18, green: 0.38, blue: 0.62),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Navigation bar (subtle)
    static let navigationBar = LinearGradient(
        colors: [
            Color.guildBackground.opacity(0.98),
            Color.white.opacity(0.85),
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - View modifiers

extension View {
    /// Full-screen gradient background behind content.
    func guildScreenBackground() -> some View {
        background(GuildGradients.screen.ignoresSafeArea())
    }

    /// Card with gradient fill, luminous border, layered shadow.
    func guildCard(cornerRadius: CGFloat = 18) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(GuildGradients.cardElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.guildActive.opacity(0.35),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .guildCardShadow()
    }

    func guildCardShadow() -> some View {
        shadow(color: Color.guildDark.opacity(0.07), radius: 3, x: 0, y: 1)
            .shadow(color: Color.guildDark.opacity(0.12), radius: 18, x: 0, y: 10)
    }

    func guildSoftShadow() -> some View {
        shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            .shadow(color: Color.guildDark.opacity(0.08), radius: 14, x: 0, y: 6)
    }

    func guildFloatingShadow() -> some View {
        shadow(color: Color.guildActive.opacity(0.28), radius: 12, x: 0, y: 6)
            .shadow(color: Color.black.opacity(0.12), radius: 22, x: 0, y: 12)
    }
}

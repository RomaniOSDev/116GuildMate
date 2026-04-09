//
//  OnboardingView.swift
//  116GuildMate
//

import SwiftUI

struct OnboardingView: View {
    @Binding var didComplete: Bool
    @State private var selection = 0

    private let pages: [(icon: String, title: String, message: String)] = [
        (
            "person.3.fill",
            "Your roster in one place",
            "Add members, specs, and roles. Mark who is active and keep raid attendance visible."
        ),
        (
            "calendar.badge.clock",
            "Raids & events",
            "Plan runs on the calendar, log bosses and duration, and adjust your schedule in seconds."
        ),
        (
            "archivebox.fill",
            "Vault & insights",
            "Track donations and stock, then open Statistics to see class spread and activity ranking."
        ),
    ]

    var body: some View {
        ZStack {
            GuildGradients.screen
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        finish()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.guildActive)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                TabView(selection: $selection) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPage(
                            systemImage: page.icon,
                            title: page.title,
                            message: page.message
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Button(action: advance) {
                    Text(selection < pages.count - 1 ? "Next" : "Get started")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(GuildGradients.fab)
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: Color.guildActive.opacity(0.35), radius: 12, x: 0, y: 6)
                        .shadow(color: Color.guildDark.opacity(0.12), radius: 20, x: 0, y: 10)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
        }
    }

    private func advance() {
        if selection < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.28)) {
                selection += 1
            }
        } else {
            finish()
        }
    }

    private func finish() {
        withAnimation(.easeInOut(duration: 0.32)) {
            didComplete = true
        }
    }
}

// MARK: - Page

private struct OnboardingPage: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 26) {
            Spacer(minLength: 24)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.guildActive.opacity(0.2),
                                Color.white.opacity(0.4),
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 90
                        )
                    )
                    .frame(width: 160, height: 160)

                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.guildActive.opacity(0.45),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 150, height: 150)

                Image(systemName: systemImage)
                    .font(.system(size: 58, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.guildActive, Color.guildDark.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolRenderingMode(.hierarchical)
            }
            .shadow(color: Color.guildDark.opacity(0.14), radius: 18, x: 0, y: 10)

            VStack(spacing: 14) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.guildDark)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(message)
                    .font(.body)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 28)
            }

            Spacer(minLength: 40)
        }
    }
}

#Preview {
    OnboardingView(didComplete: .constant(false))
}

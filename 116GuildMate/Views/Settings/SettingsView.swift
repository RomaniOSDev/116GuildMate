//
//  SettingsView.swift
//  116GuildMate
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        rateApp()
                    } label: {
                        Label("Rate us", systemImage: "star.fill")
                            .foregroundColor(.guildDark)
                    }

                    Button {
                        openURL(.privacyPolicy)
                    } label: {
                        Label("Privacy Policy", systemImage: "lock.shield.fill")
                            .foregroundColor(.guildDark)
                    }

                    Button {
                        openURL(.termsOfUse)
                    } label: {
                        Label("Terms of Use", systemImage: "doc.text.fill")
                            .foregroundColor(.guildDark)
                    }
                } header: {
                    Text("Support & legal")
                        .foregroundColor(.guildDark)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
        .background(GuildGradients.screen.ignoresSafeArea())
    }

    private func openURL(_ link: GuildExternalLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    SettingsView()
}

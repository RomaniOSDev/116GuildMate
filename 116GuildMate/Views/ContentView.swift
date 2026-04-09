//
//  ContentView.swift
//  116GuildMate
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GuildMateViewModel()
    @State private var selectedTab = 0
    @AppStorage("guildmate_onboarding_completed") private var onboardingCompleted = false

    var body: some View {
        Group {
            if onboardingCompleted {
                mainTabView
            } else {
                OnboardingView(didComplete: $onboardingCompleted)
            }
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            MembersView(viewModel: viewModel)
                .tabItem {
                    Label("Members", systemImage: "person.3.fill")
                }
                .tag(1)

            RaidsView(viewModel: viewModel)
                .tabItem {
                    Label("Raids", systemImage: "flag.fill")
                }
                .tag(2)

            ResourcesView(viewModel: viewModel)
                .tabItem {
                    Label("Resources", systemImage: "gift.fill")
                }
                .tag(3)

            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(4)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
        .tint(.guildActive)
    }
}

#Preview {
    ContentView()
}

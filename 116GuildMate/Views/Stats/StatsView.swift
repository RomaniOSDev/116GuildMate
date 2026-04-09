//
//  StatsView.swift
//  116GuildMate
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: GuildMateViewModel

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    StatCard(
                        title: "Members",
                        value: "\(viewModel.totalMembers)",
                        icon: "person.3.fill",
                        color: .guildActive
                    )
                    StatCard(
                        title: "Active",
                        value: "\(viewModel.activeMembers)",
                        icon: "star.fill",
                        color: .guildActive
                    )
                    StatCard(
                        title: "Raids",
                        value: "\(viewModel.totalRaids)",
                        icon: "flag.fill",
                        color: .guildActive
                    )
                    StatCard(
                        title: "Avg level",
                        value: String(format: "%.1f", viewModel.averageLevel),
                        icon: "chart.line.uptrend.xyaxis",
                        color: .guildActive
                    )
                }
                .padding(.horizontal)

                rosterSection
                    .padding(.top, 8)

                rankingSection
                    .padding(.vertical, 12)
            }
            .guildScreenBackground()
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private var rosterSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitleBar(title: "Roster by class", icon: "person.3.sequence.fill")
            ForEach(Array(viewModel.classDistribution.enumerated()), id: \.element.id) { idx, item in
                HStack {
                    Image(systemName: item.icon)
                        .foregroundColor(.guildActive)
                        .frame(width: 30)
                        .symbolRenderingMode(.hierarchical)
                    Text(item.name)
                        .foregroundColor(.guildDark)
                    Spacer()
                    Text("\(item.count)")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.guildActive)
                    Text("members")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
                if idx < viewModel.classDistribution.count - 1 {
                    Divider()
                        .background(Color.guildActive.opacity(0.15))
                }
            }
        }
        .padding(18)
        .guildCard(cornerRadius: 20)
        .padding(.horizontal)
    }

    private var rankingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitleBar(title: "Activity ranking", icon: "chart.bar.fill")
            ForEach(Array(viewModel.activeMembersRanking.enumerated()), id: \.element.id) { index, member in
                HStack {
                    Text("\(index + 1)")
                        .font(.headline.weight(.bold))
                        .foregroundColor(index == 0 ? .white : .guildActive)
                        .frame(width: 32, height: 32)
                        .background {
                            if index == 0 {
                                Circle().fill(GuildGradients.chipSelected)
                            } else {
                                Circle().fill(GuildGradients.badge)
                            }
                        }
                        .shadow(color: Color.guildActive.opacity(0.25), radius: 6, x: 0, y: 3)
                    Text(member.name)
                        .foregroundColor(.guildDark)
                    Spacer()
                    Text(String(format: "%.0f%%", member.raidAttendance))
                        .foregroundColor(.guildActive)
                        .font(.headline.weight(.bold))
                }
                .padding(.vertical, 6)
            }
        }
        .padding(18)
        .guildCard(cornerRadius: 20)
        .padding(.horizontal)
    }

    private func sectionTitleBar(title: String, icon: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(GuildGradients.deepAccent)
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.guildDark.opacity(0.22), radius: 8, x: 0, y: 4)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.guildDark)
        }
    }
}

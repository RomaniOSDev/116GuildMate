//
//  HomeView.swift
//  116GuildMate
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GuildMateViewModel
    @Binding var selectedTab: Int

    @State private var selectedEvent: GuildEvent?
    @State private var selectedRaid: Raid?
    @State private var showAddEventSheet = false
    @State private var showAddRaidSheet = false
    @State private var showAddMemberSheet = false
    @State private var showEditGuildName = false
    @State private var guildNameDraft = ""

    private let statsColumns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroCard

                    LazyVGrid(columns: statsColumns, spacing: 12) {
                        HomeStatTile(
                            title: "Members",
                            value: "\(viewModel.totalMembers)",
                            icon: "person.3.fill",
                            accent: .guildActive
                        )
                        HomeStatTile(
                            title: "Online today",
                            value: "\(viewModel.onlineCount)",
                            icon: "network",
                            accent: .guildActive
                        )
                        HomeStatTile(
                            title: "Raids logged",
                            value: "\(viewModel.totalRaids)",
                            icon: "flag.fill",
                            accent: .guildActive
                        )
                        HomeStatTile(
                            title: "Guild level",
                            value: "\(viewModel.guildLevel)",
                            icon: "star.fill",
                            accent: .guildActive
                        )
                    }

                    quickActionsRow

                    VStack(alignment: .leading, spacing: 12) {
                        HomeSectionHeader(
                            title: "Upcoming events",
                            icon: "calendar",
                            actionTitle: nil,
                            action: nil
                        )
                        upcomingEventsBlock
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HomeSectionHeader(
                            title: "Recent raids",
                            icon: "flag.2.crossed",
                            actionTitle: "Open list",
                            action: { selectedTab = 2 }
                        )
                        recentRaidsBlock
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shortcuts")
                            .font(.headline)
                            .foregroundColor(.guildDark)
                            .padding(.horizontal, 4)
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10),
                            ],
                            spacing: 10
                        ) {
                            HomeTabShortcut(title: "Roster", icon: "person.3.fill") {
                                selectedTab = 1
                            }
                            HomeTabShortcut(title: "Raids", icon: "flag.fill") {
                                selectedTab = 2
                            }
                            HomeTabShortcut(title: "Vault", icon: "gift.fill") {
                                selectedTab = 3
                            }
                            HomeTabShortcut(title: "Reports", icon: "chart.bar.fill") {
                                selectedTab = 4
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 88)
            }
            .guildScreenBackground()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(item: $selectedEvent) { event in
                EventEditorSheet(viewModel: viewModel, event: event)
            }
            .sheet(item: $selectedRaid) { raid in
                RaidEditorSheet(viewModel: viewModel, raid: raid)
            }
            .sheet(isPresented: $showAddEventSheet) {
                EventEditorSheet(viewModel: viewModel, event: nil)
            }
            .sheet(isPresented: $showAddRaidSheet) {
                AddRaidView(viewModel: viewModel)
            }
            .sheet(isPresented: $showAddMemberSheet) {
                MemberEditorSheet(viewModel: viewModel, member: nil)
            }
            .sheet(isPresented: $showEditGuildName) {
                NavigationStack {
                    Form {
                        TextField("Guild name", text: $guildNameDraft)
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Guild name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showEditGuildName = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let trimmed = guildNameDraft.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmed.isEmpty {
                                    viewModel.guildName = trimmed
                                }
                                viewModel.saveToUserDefaults()
                                showEditGuildName = false
                            }
                        }
                    }
                }
                .background(GuildGradients.screen.ignoresSafeArea())
                .presentationDetents([.medium])
            }
            .safeAreaInset(edge: .bottom) {
                addRaidFloatingButton
            }
        }
    }

    private var heroCapsuleBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text("Level \(viewModel.guildLevel)")
                .font(.caption.weight(.semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(GuildGradients.chipSelected)
        )
        .shadow(color: Color.guildActive.opacity(0.35), radius: 8, x: 0, y: 4)
    }

    private var heroCard: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(GuildGradients.hero)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    heroCapsuleBadge
                    Spacer()
                    Button {
                        guildNameDraft = viewModel.guildName
                        showEditGuildName = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.guildActive, Color.white)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Edit guild name")
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Good day,")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.guildActive)
                    Text(viewModel.guildName)
                        .font(.title.weight(.bold))
                        .foregroundColor(.guildDark)
                        .lineLimit(2)
                    Text(formattedTodayLong())
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 20) {
                    heroMiniStat(title: "Active", value: "\(viewModel.activeMembers)")
                    heroMiniStat(title: "Raids", value: "\(viewModel.totalRaids)")
                    heroMiniStat(title: "Avg lvl", value: String(format: "%.0f", viewModel.averageLevel))
                }
                .padding(.top, 4)
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.guildActive.opacity(0.4),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .guildCardShadow()
    }

    private func heroMiniStat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundColor(.guildDark)
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var quickActionsRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HomeSectionHeader(title: "Quick actions", icon: "bolt.fill", actionTitle: nil, action: nil)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    HomeQuickAction(title: "New raid", icon: "plus.circle.fill") {
                        showAddRaidSheet = true
                    }
                    HomeQuickAction(title: "Schedule event", icon: "calendar.badge.plus") {
                        showAddEventSheet = true
                    }
                    HomeQuickAction(title: "Add member", icon: "person.badge.plus") {
                        showAddMemberSheet = true
                    }
                    HomeQuickAction(title: "Guild vault", icon: "archivebox.fill") {
                        selectedTab = 3
                    }
                }
                .padding(.vertical, 4)
                .padding(.trailing, 8)
            }
        }
    }

    @ViewBuilder
    private var upcomingEventsBlock: some View {
        if viewModel.upcomingEvents.isEmpty {
            HomeEmptyState(
                icon: "calendar.badge.clock",
                message: "No scheduled events. Plan your next raid or meeting.",
                actionTitle: "Create event"
            ) {
                showAddEventSheet = true
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.upcomingEvents) { event in
                        HomeEventCard(event: event)
                            .onTapGesture {
                                selectedEvent = event
                            }
                    }
                    Button {
                        showAddEventSheet = true
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white, Color.guildActive)
                            Text("Add")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.guildDark)
                        }
                        .frame(width: 104, height: 160)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(GuildGradients.insetField)
                        )
                        .guildSoftShadow()
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(
                                    Color.guildActive.opacity(0.35),
                                    style: StrokeStyle(lineWidth: 2, dash: [8, 6])
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
        }
    }

    @ViewBuilder
    private var recentRaidsBlock: some View {
        if viewModel.recentRaids.isEmpty {
            HomeEmptyState(
                icon: "flag.slash",
                message: "No raids yet. Log your first run to track history.",
                actionTitle: "Log raid"
            ) {
                showAddRaidSheet = true
            }
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.recentRaids.prefix(5)) { raid in
                    HomeRaidRow(raid: raid)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedRaid = raid
                        }
                        .contextMenu {
                            Button {
                                viewModel.toggleRaidCompletion(raid)
                            } label: {
                                Label(
                                    raid.isCompleted ? "Mark incomplete" : "Mark cleared",
                                    systemImage: "checkmark.circle"
                                )
                            }
                            Button(role: .destructive) {
                                viewModel.deleteRaid(raid)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }

    private var addRaidFloatingButton: some View {
        HStack {
            Spacer()
            Button {
                showAddRaidSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 58, height: 58)
                    .background(
                        Circle()
                            .fill(GuildGradients.fab)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.35), lineWidth: 1.5)
                    )
                    .guildFloatingShadow()
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add raid")
            .padding(.trailing, 22)
            .padding(.bottom, 6)
        }
    }
}

//
//  RaidsView.swift
//  116GuildMate
//

import SwiftUI

struct RaidsView: View {
    @ObservedObject var viewModel: GuildMateViewModel
    @State private var selectedRaid: Raid?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.raids.sorted { $0.date > $1.date }) { raid in
                    RaidDetailCard(raid: raid)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            selectedRaid = raid
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteRaid(raid)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                viewModel.toggleRaidCompletion(raid)
                            } label: {
                                Label(
                                    raid.isCompleted ? "Mark incomplete" : "Mark cleared",
                                    systemImage: "checkmark"
                                )
                            }
                            .tint(.guildActive)
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .guildScreenBackground()
            .navigationTitle("Raids")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(item: $selectedRaid) { raid in
                RaidEditorSheet(viewModel: viewModel, raid: raid)
            }
        }
    }
}

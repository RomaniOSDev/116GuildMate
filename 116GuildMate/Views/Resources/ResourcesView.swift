//
//  ResourcesView.swift
//  116GuildMate
//

import SwiftUI

struct ResourcesView: View {
    @ObservedObject var viewModel: GuildMateViewModel
    @State private var showAddResourceSheet = false
    @State private var donateResource: GuildResource?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.resources) { resource in
                    ResourceCard(resource: resource)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteResource(resource)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                donateResource = resource
                            } label: {
                                Label("Donate", systemImage: "heart")
                            }
                            .tint(.guildActive)
                        }
                }
                Section {
                    Button {
                        showAddResourceSheet = true
                    } label: {
                        Text("Add resource")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(GuildGradients.chipSelected)
                            )
                            .shadow(color: Color.guildActive.opacity(0.38), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 24, trailing: 16))
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .guildScreenBackground()
            .navigationTitle("Guild resources")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(isPresented: $showAddResourceSheet) {
                ResourceEditorSheet(viewModel: viewModel, resource: nil)
            }
            .sheet(item: $donateResource) { resource in
                DonateResourceSheet(viewModel: viewModel, resource: resource)
            }
        }
    }
}

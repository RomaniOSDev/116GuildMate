//
//  MembersView.swift
//  116GuildMate
//

import SwiftUI

struct MembersView: View {
    @ObservedObject var viewModel: GuildMateViewModel
    @State private var selectedMember: GuildMember?
    @State private var showAddMemberSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(title: "All", isSelected: viewModel.selectedRole == nil, color: .guildActive) {
                                viewModel.selectedRole = nil
                            }
                            ForEach(MemberRole.allCases, id: \.self) { role in
                                FilterChip(title: role.rawValue, isSelected: viewModel.selectedRole == role, color: .guildActive) {
                                    viewModel.selectedRole = role
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(title: "All classes", isSelected: viewModel.selectedClass == nil, color: .guildActive) {
                                viewModel.selectedClass = nil
                            }
                            ForEach(MemberClass.allCases, id: \.self) { class_ in
                                FilterChip(title: class_.rawValue, isSelected: viewModel.selectedClass == class_, color: .guildActive) {
                                    viewModel.selectedClass = class_
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(GuildGradients.insetField)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.guildActive.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.guildDark.opacity(0.08), radius: 12, x: 0, y: 6)
                .padding(.horizontal, 12)
                .padding(.top, 8)

                TextField("Search name", text: $viewModel.searchText)
                    .font(.body)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(GuildGradients.insetField)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.guildActive.opacity(0.28), Color.white.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.guildDark.opacity(0.07), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                List {
                    ForEach(viewModel.filteredMembers) { member in
                        MemberCard(member: member)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                selectedMember = member
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteMember(member)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    viewModel.toggleActiveStatus(member)
                                } label: {
                                    Label(
                                        member.isActive ? "Deactivate" : "Activate",
                                        systemImage: "power"
                                    )
                                }
                                .tint(.guildActive)
                            }
                    }
                    Section {
                        Button {
                            showAddMemberSheet = true
                        } label: {
                            Text("Add member")
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
            }
            .guildScreenBackground()
            .navigationTitle("Members")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(GuildGradients.navigationBar, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(item: $selectedMember) { member in
                MemberEditorSheet(viewModel: viewModel, member: member)
            }
            .sheet(isPresented: $showAddMemberSheet) {
                MemberEditorSheet(viewModel: viewModel, member: nil)
            }
        }
    }
}

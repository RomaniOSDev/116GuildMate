//
//  DonateResourceSheet.swift
//  116GuildMate
//

import SwiftUI

struct DonateResourceSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let resource: GuildResource

    @Environment(\.dismiss) private var dismiss

    @State private var selectedMemberId: UUID?
    @State private var quantityText = "1"

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.members.isEmpty {
                    Text("Add a member first to record donations.")
                        .foregroundColor(.guildDark)
                        .padding()
                } else {
                    Form {
                        Section("Resource") {
                            Text(resource.name)
                                .foregroundColor(.guildDark)
                        }
                        Section("Member") {
                            Picker("Member", selection: Binding(
                                get: { selectedMemberId ?? viewModel.members.first!.id },
                                set: { selectedMemberId = $0 }
                            )) {
                                ForEach(viewModel.members) { member in
                                    Text(member.name).tag(member.id)
                                }
                            }
                        }
                        Section("Donation") {
                            TextField("Quantity", text: $quantityText)
                                .keyboardType(.numberPad)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Donate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { donate() }
                        .disabled(viewModel.members.isEmpty || (Int(quantityText) ?? 0) <= 0)
                }
            }
            .onAppear {
                if selectedMemberId == nil {
                    selectedMemberId = viewModel.members.first?.id
                }
            }
        }
        .background(GuildGradients.screen.ignoresSafeArea())
    }

    private func donate() {
        guard let memberId = selectedMemberId ?? viewModel.members.first?.id,
              let member = viewModel.members.first(where: { $0.id == memberId }),
              let q = Int(quantityText), q > 0 else { return }
        viewModel.donateToResource(resource, memberId: memberId, memberName: member.name, quantity: q)
        dismiss()
    }
}

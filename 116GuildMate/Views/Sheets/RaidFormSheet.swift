//
//  RaidFormSheet.swift
//  116GuildMate
//

import SwiftUI

struct RaidFormSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let raid: Raid?

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var durationText = "120"
    @State private var bossesText = ""
    @State private var notes = ""
    @State private var isCompleted = false
    @State private var selectedParticipants: Set<UUID> = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Raid name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Duration (minutes)", text: $durationText)
                        .keyboardType(.numberPad)
                }
                Section("Bosses") {
                    TextField("Comma-separated", text: $bossesText, axis: .vertical)
                        .lineLimit(2...4)
                }
                Section("Participants") {
                    ForEach(viewModel.members) { member in
                        Toggle(isOn: binding(for: member.id)) {
                            Text(member.name)
                        }
                    }
                }
                Section("Status") {
                    Toggle("Completed", isOn: $isCompleted)
                }
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                if raid != nil {
                    Section {
                        Button(role: .destructive) {
                            if let raid {
                                viewModel.deleteRaid(raid)
                            }
                            dismiss()
                        } label: {
                            Text("Delete raid")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(raid == nil ? "New raid" : "Raid")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let raid {
                    name = raid.name
                    date = raid.date
                    durationText = String(raid.duration)
                    bossesText = raid.bossNames.joined(separator: ", ")
                    notes = raid.notes ?? ""
                    isCompleted = raid.isCompleted
                    selectedParticipants = Set(raid.participants)
                }
            }
        }
        .background(GuildGradients.screen.ignoresSafeArea())
    }

    private func binding(for id: UUID) -> Binding<Bool> {
        Binding(
            get: { selectedParticipants.contains(id) },
            set: { isOn in
                if isOn {
                    selectedParticipants.insert(id)
                } else {
                    selectedParticipants.remove(id)
                }
            }
        )
    }

    private func parseBosses(_ text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let duration = Int(durationText) ?? 0
        let bosses = parseBosses(bossesText)
        let participantIds = Array(selectedParticipants)

        if let existing = raid {
            var updated = existing
            updated.name = trimmedName
            updated.date = date
            updated.duration = max(duration, 0)
            updated.bossNames = bosses
            updated.participants = participantIds
            updated.notes = notes.isEmpty ? nil : notes
            updated.isCompleted = isCompleted
            viewModel.updateRaid(updated)
        } else {
            let newRaid = Raid(
                id: UUID(),
                name: trimmedName,
                date: date,
                duration: max(duration, 0),
                bossNames: bosses,
                participants: participantIds,
                loot: [],
                notes: notes.isEmpty ? nil : notes,
                isCompleted: isCompleted,
                createdAt: Date()
            )
            viewModel.addRaid(newRaid)
        }
        dismiss()
    }
}

struct AddRaidView: View {
    @ObservedObject var viewModel: GuildMateViewModel

    var body: some View {
        RaidFormSheet(viewModel: viewModel, raid: nil)
    }
}

struct RaidEditorSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let raid: Raid

    var body: some View {
        RaidFormSheet(viewModel: viewModel, raid: raid)
    }
}

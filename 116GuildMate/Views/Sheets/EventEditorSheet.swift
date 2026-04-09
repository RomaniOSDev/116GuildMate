//
//  EventEditorSheet.swift
//  116GuildMate
//

import SwiftUI

struct EventEditorSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let event: GuildEvent?

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var type = "Raid"
    @State private var description = ""
    @State private var notes = ""
    @State private var selectedParticipants: Set<UUID> = []

    private let eventTypes = ["Raid", "PvP", "Quest", "Meeting"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    DatePicker("Date & time", selection: $date)
                    Picker("Type", selection: $type) {
                        ForEach(eventTypes, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section("Description") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Participants") {
                    ForEach(viewModel.members) { member in
                        Toggle(isOn: binding(for: member.id)) {
                            Text(member.name)
                        }
                    }
                }
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                if event != nil {
                    Section {
                        Button(role: .destructive) {
                            if let event {
                                viewModel.deleteEvent(event)
                            }
                            dismiss()
                        } label: {
                            Text("Delete event")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(event == nil ? "New event" : "Event")
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
                if let event {
                    name = event.name
                    date = event.date
                    type = event.type
                    description = event.description
                    notes = event.notes ?? ""
                    selectedParticipants = Set(event.participants)
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

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let existing = event {
            var updated = existing
            updated.name = trimmedName
            updated.date = date
            updated.type = type
            updated.description = description
            updated.notes = notes.isEmpty ? nil : notes
            updated.participants = Array(selectedParticipants)
            viewModel.updateEvent(updated)
        } else {
            let newEvent = GuildEvent(
                id: UUID(),
                name: trimmedName,
                date: date,
                type: type,
                description: description,
                participants: Array(selectedParticipants),
                notes: notes.isEmpty ? nil : notes,
                createdAt: Date()
            )
            viewModel.addEvent(newEvent)
        }
        dismiss()
    }
}

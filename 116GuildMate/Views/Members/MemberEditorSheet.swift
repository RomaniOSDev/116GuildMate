//
//  MemberEditorSheet.swift
//  116GuildMate
//

import SwiftUI

struct MemberEditorSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let member: GuildMember?

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var level = 70
    @State private var class_: MemberClass = .warrior
    @State private var role: MemberRole = .member
    @State private var professions: Set<Profession> = []
    @State private var notes = ""
    @State private var discordTag = ""
    @State private var isActive = true
    @State private var joinedDate = Date()
    @State private var hasLastOnline = false
    @State private var lastOnline = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Name", text: $name)
                    Stepper("Level: \(level)", value: $level, in: 1...80)
                    Picker("Class", selection: $class_) {
                        ForEach(MemberClass.allCases, id: \.self) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    Picker("Role", selection: $role) {
                        ForEach(MemberRole.allCases, id: \.self) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                }
                Section("Professions") {
                    ForEach(Profession.allCases, id: \.self) { p in
                        Toggle(isOn: binding(for: p)) {
                            Label(p.rawValue, systemImage: p.icon)
                        }
                    }
                }
                Section("Activity") {
                    Toggle("Active member", isOn: $isActive)
                    DatePicker("Joined", selection: $joinedDate, displayedComponents: .date)
                    Toggle("Set last online", isOn: $hasLastOnline)
                    if hasLastOnline {
                        DatePicker("Last online", selection: $lastOnline, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                Section("Extra") {
                    TextField("Discord", text: $discordTag)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                if member != nil {
                    Section {
                        Button(role: .destructive) {
                            if let member {
                                viewModel.deleteMember(member)
                            }
                            dismiss()
                        } label: {
                            Text("Delete member")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(member == nil ? "New member" : "Member")
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
                if let member {
                    name = member.name
                    level = member.level
                    class_ = member.class_
                    role = member.role
                    professions = Set(member.professions)
                    notes = member.notes ?? ""
                    discordTag = member.discordTag ?? ""
                    isActive = member.isActive
                    joinedDate = member.joinedDate
                    if let lo = member.lastOnline {
                        hasLastOnline = true
                        lastOnline = lo
                    }
                }
            }
        }
        .background(GuildGradients.screen.ignoresSafeArea())
    }

    private func binding(for profession: Profession) -> Binding<Bool> {
        Binding(
            get: { professions.contains(profession) },
            set: { isOn in
                if isOn {
                    professions.insert(profession)
                } else {
                    professions.remove(profession)
                }
            }
        )
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let profs = Array(professions).sorted { $0.rawValue < $1.rawValue }
        let lo: Date? = hasLastOnline ? lastOnline : nil
        if let existing = member {
            var updated = existing
            updated.name = trimmedName
            updated.level = level
            updated.class_ = class_
            updated.role = role
            updated.professions = profs
            updated.notes = notes.isEmpty ? nil : notes
            updated.discordTag = discordTag.isEmpty ? nil : discordTag
            updated.isActive = isActive
            updated.joinedDate = joinedDate
            updated.lastOnline = lo
            viewModel.updateMember(updated)
        } else {
            let newMember = GuildMember(
                id: UUID(),
                name: trimmedName,
                level: level,
                class_: class_,
                role: role,
                professions: profs,
                mainCharacterId: role == .alt ? nil : nil,
                mainCharacterName: nil,
                joinedDate: joinedDate,
                lastOnline: lo,
                notes: notes.isEmpty ? nil : notes,
                isActive: isActive,
                raidAttendance: 0,
                discordTag: discordTag.isEmpty ? nil : discordTag,
                createdAt: Date()
            )
            viewModel.addMember(newMember)
            viewModel.recalculateMemberAttendance()
        }
        dismiss()
    }
}

//
//  ResourceEditorSheet.swift
//  116GuildMate
//

import SwiftUI

struct ResourceEditorSheet: View {
    @ObservedObject var viewModel: GuildMateViewModel
    let resource: GuildResource?

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var quantityText = "0"
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Resource") {
                    TextField("Name", text: $name)
                    TextField("Quantity", text: $quantityText)
                        .keyboardType(.numberPad)
                }
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                if resource != nil {
                    Section {
                        Button(role: .destructive) {
                            if let resource {
                                viewModel.deleteResource(resource)
                            }
                            dismiss()
                        } label: {
                            Text("Delete resource")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(resource == nil ? "New resource" : "Resource")
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
                if let resource {
                    name = resource.name
                    quantityText = String(resource.quantity)
                    notes = resource.notes ?? ""
                }
            }
        }
        .background(GuildGradients.screen.ignoresSafeArea())
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let qty = Int(quantityText) ?? 0
        if let existing = resource {
            var updated = existing
            updated.name = trimmedName
            updated.quantity = max(qty, 0)
            updated.notes = notes.isEmpty ? nil : notes
            viewModel.updateResource(updated)
        } else {
            let newResource = GuildResource(
                id: UUID(),
                name: trimmedName,
                quantity: max(qty, 0),
                donatedBy: [],
                notes: notes.isEmpty ? nil : notes
            )
            viewModel.addResource(newResource)
        }
        dismiss()
    }
}

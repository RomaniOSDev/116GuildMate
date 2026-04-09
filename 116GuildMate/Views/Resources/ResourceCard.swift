//
//  ResourceCard.swift
//  116GuildMate
//

import SwiftUI

struct ResourceCard: View {
    let resource: GuildResource

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(resource.name)
                        .font(.headline)
                        .foregroundColor(.guildDark)
                    if let notes = resource.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
                Spacer()
                Text("\(resource.quantity) pcs")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(GuildGradients.chipSelected)
                    )
                    .shadow(color: Color.guildActive.opacity(0.42), radius: 8, x: 0, y: 4)
            }

            if !resource.donatedBy.isEmpty {
                Text("Donations:")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.guildDark.opacity(0.75))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(resource.donatedBy.prefix(3)) { donation in
                            Text("\(donation.memberName): +\(donation.quantity)")
                                .font(.caption2.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(GuildGradients.badge)
                                )
                                .foregroundColor(.guildActive)
                        }
                        if resource.donatedBy.count > 3 {
                            Text("+\(resource.donatedBy.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .padding(16)
        .guildCard(cornerRadius: 18)
    }
}

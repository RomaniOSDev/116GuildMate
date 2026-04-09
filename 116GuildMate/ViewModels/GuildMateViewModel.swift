//
//  GuildMateViewModel.swift
//  116GuildMate
//

import Combine
import Foundation

@MainActor
final class GuildMateViewModel: ObservableObject {
    @Published var members: [GuildMember] = []
    @Published var raids: [Raid] = []
    @Published var events: [GuildEvent] = []
    @Published var resources: [GuildResource] = []

    @Published var guildName: String = "Silver Vanguard" {
        didSet {
            UserDefaults.standard.set(guildName, forKey: guildNameKey)
        }
    }

    @Published var selectedRole: MemberRole?
    @Published var selectedClass: MemberClass?
    @Published var searchText: String = ""

    var totalMembers: Int { members.count }

    var activeMembers: Int { members.filter(\.isActive).count }

    var onlineCount: Int {
        members.filter {
            guard let lastOnline = $0.lastOnline else { return false }
            return Calendar.current.isDateInToday(lastOnline)
        }.count
    }

    var totalRaids: Int { raids.count }

    var guildLevel: Int {
        let levelSum = members.reduce(0) { $0 + $1.level }
        let totalExp = totalRaids * 100 + levelSum / 10
        return totalExp / 1000 + 1
    }

    var averageLevel: Double {
        guard !members.isEmpty else { return 0 }
        return Double(members.reduce(0) { $0 + $1.level }) / Double(members.count)
    }

    var upcomingEvents: [GuildEvent] {
        events
            .filter { $0.date >= Date() }
            .sorted { $0.date < $1.date }
            .prefix(5)
            .map { $0 }
    }

    var recentRaids: [Raid] {
        Array(raids.sorted { $0.date > $1.date }.prefix(10))
    }

    var filteredMembers: [GuildMember] {
        var result = members
        if let role = selectedRole {
            result = result.filter { $0.role == role }
        }
        if let class_ = selectedClass {
            result = result.filter { $0.class_ == class_ }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result.sorted { $0.role.priority < $1.role.priority }
    }

    struct ClassDistributionItem: Identifiable {
        let name: String
        let icon: String
        let count: Int

        var id: String { name }
    }

    var classDistribution: [ClassDistributionItem] {
        let grouped = Dictionary(grouping: members, by: \.class_)
        return grouped.map { class_, members in
            ClassDistributionItem(name: class_.rawValue, icon: class_.icon, count: members.count)
        }
        .sorted { $0.count > $1.count }
    }

    var activeMembersRanking: [GuildMember] {
        members
            .filter(\.isActive)
            .sorted { $0.raidAttendance > $1.raidAttendance }
            .prefix(10)
            .map { $0 }
    }

    func addMember(_ member: GuildMember) {
        members.append(member)
        saveToUserDefaults()
    }

    func updateMember(_ member: GuildMember) {
        if let index = members.firstIndex(where: { $0.id == member.id }) {
            members[index] = member
            saveToUserDefaults()
        }
    }

    func deleteMember(_ member: GuildMember) {
        members.removeAll { $0.id == member.id }
        saveToUserDefaults()
    }

    func toggleActiveStatus(_ member: GuildMember) {
        if let index = members.firstIndex(where: { $0.id == member.id }) {
            members[index].isActive.toggle()
            saveToUserDefaults()
        }
    }

    func addRaid(_ raid: Raid) {
        raids.append(raid)
        updateAttendance()
        saveToUserDefaults()
    }

    func updateRaid(_ raid: Raid) {
        if let index = raids.firstIndex(where: { $0.id == raid.id }) {
            raids[index] = raid
            updateAttendance()
            saveToUserDefaults()
        }
    }

    func deleteRaid(_ raid: Raid) {
        raids.removeAll { $0.id == raid.id }
        updateAttendance()
        saveToUserDefaults()
    }

    func toggleRaidCompletion(_ raid: Raid) {
        if let index = raids.firstIndex(where: { $0.id == raid.id }) {
            raids[index].isCompleted.toggle()
            saveToUserDefaults()
        }
    }

    func addEvent(_ event: GuildEvent) {
        events.append(event)
        saveToUserDefaults()
    }

    func updateEvent(_ event: GuildEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveToUserDefaults()
        }
    }

    func deleteEvent(_ event: GuildEvent) {
        events.removeAll { $0.id == event.id }
        saveToUserDefaults()
    }

    func addResource(_ resource: GuildResource) {
        resources.append(resource)
        saveToUserDefaults()
    }

    func updateResource(_ resource: GuildResource) {
        if let index = resources.firstIndex(where: { $0.id == resource.id }) {
            resources[index] = resource
            saveToUserDefaults()
        }
    }

    func deleteResource(_ resource: GuildResource) {
        resources.removeAll { $0.id == resource.id }
        saveToUserDefaults()
    }

    func donateToResource(_ resource: GuildResource, memberId: UUID, memberName: String, quantity: Int) {
        guard let index = resources.firstIndex(where: { $0.id == resource.id }) else { return }
        let donation = ResourceDonation(
            id: UUID(),
            memberId: memberId,
            memberName: memberName,
            quantity: quantity,
            date: Date()
        )
        resources[index].donatedBy.append(donation)
        resources[index].quantity += quantity
        saveToUserDefaults()
    }

    func recalculateMemberAttendance() {
        updateAttendance()
    }

    private func updateAttendance() {
        let total = raids.count
        for i in members.indices {
            let memberRaids = raids.filter { $0.participants.contains(members[i].id) }
            if total > 0 {
                members[i].raidAttendance = Double(memberRaids.count) / Double(total) * 100
            } else {
                members[i].raidAttendance = 0
            }
        }
        saveToUserDefaults()
    }

    private let membersKey = "guildmate_members"
    private let raidsKey = "guildmate_raids"
    private let eventsKey = "guildmate_events"
    private let resourcesKey = "guildmate_resources"
    private let guildNameKey = "guildmate_guild_name"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(members) {
            UserDefaults.standard.set(encoded, forKey: membersKey)
        }
        if let encoded = try? JSONEncoder().encode(raids) {
            UserDefaults.standard.set(encoded, forKey: raidsKey)
        }
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: eventsKey)
        }
        if let encoded = try? JSONEncoder().encode(resources) {
            UserDefaults.standard.set(encoded, forKey: resourcesKey)
        }
        UserDefaults.standard.set(guildName, forKey: guildNameKey)
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: membersKey),
           let decoded = try? JSONDecoder().decode([GuildMember].self, from: data) {
            members = decoded
        }
        if let data = UserDefaults.standard.data(forKey: raidsKey),
           let decoded = try? JSONDecoder().decode([Raid].self, from: data) {
            raids = decoded
        }
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([GuildEvent].self, from: data) {
            events = decoded
        }
        if let data = UserDefaults.standard.data(forKey: resourcesKey),
           let decoded = try? JSONDecoder().decode([GuildResource].self, from: data) {
            resources = decoded
        }
        if let storedName = UserDefaults.standard.string(forKey: guildNameKey), !storedName.isEmpty {
            guildName = storedName
        }
        if members.isEmpty {
            loadDemoData()
        }
    }

    private func loadDemoData() {
        let member1 = GuildMember(
            id: UUID(),
            name: "Arthas",
            level: 80,
            class_: .deathKnight,
            role: .master,
            professions: [.mining, .blacksmithing],
            mainCharacterId: nil,
            mainCharacterName: nil,
            joinedDate: Date().addingTimeInterval(-86400 * 180),
            lastOnline: Date().addingTimeInterval(-3600),
            notes: "Guild leader",
            isActive: true,
            raidAttendance: 95,
            discordTag: "Arthas#1234",
            createdAt: Date()
        )

        let member2 = GuildMember(
            id: UUID(),
            name: "Jaina",
            level: 80,
            class_: .mage,
            role: .officer,
            professions: [.herbalism, .alchemy],
            mainCharacterId: nil,
            mainCharacterName: nil,
            joinedDate: Date().addingTimeInterval(-86400 * 150),
            lastOnline: Date().addingTimeInterval(-7200),
            notes: "Raid leader",
            isActive: true,
            raidAttendance: 90,
            discordTag: "Jaina#5678",
            createdAt: Date()
        )

        let member3 = GuildMember(
            id: UUID(),
            name: "Illidan",
            level: 80,
            class_: .demonHunter,
            role: .member,
            professions: [.skinning, .leatherworking],
            mainCharacterId: nil,
            mainCharacterName: nil,
            joinedDate: Date().addingTimeInterval(-86400 * 30),
            lastOnline: Date().addingTimeInterval(-86400 * 2),
            notes: nil,
            isActive: true,
            raidAttendance: 75,
            discordTag: "Illidan#9012",
            createdAt: Date()
        )

        members = [member1, member2, member3]

        let raid = Raid(
            id: UUID(),
            name: "Icecrown Citadel",
            date: Date().addingTimeInterval(-86400 * 3),
            duration: 180,
            bossNames: ["Lord Marrowgar", "Lady Deathwhisper", "The Lich King"],
            participants: [member1.id, member2.id, member3.id],
            loot: [],
            notes: "Clean run",
            isCompleted: true,
            createdAt: Date()
        )

        raids = [raid]

        let event = GuildEvent(
            id: UUID(),
            name: "Icecrown Raid Night",
            date: Date().addingTimeInterval(86400 * 2),
            type: "Raid",
            description: "Full clear attempt",
            participants: [],
            notes: nil,
            createdAt: Date()
        )

        events = [event]

        let resource = GuildResource(
            id: UUID(),
            name: "Gold",
            quantity: 15000,
            donatedBy: [],
            notes: "Guild treasury"
        )

        resources = [resource]
        saveToUserDefaults()
    }
}

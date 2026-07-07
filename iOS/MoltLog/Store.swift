import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [MoltLogEntry] = []

    // Free tier limit is intentionally well above the seed data count
    // so a fresh install never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("MoltLog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            seed()
            save()
        }
    }

    var isAtFreeLimit: Bool {
        entries.count >= Store.freeLimit
    }

    func canAdd(isPro: Bool) -> Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: MoltLogEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: MoltLogEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: MoltLogEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func seed() {
        let now = Date()
        entries = [
            MoltLogEntry(title: "First Molt", date: now, animal: "", notes: "", notes: "Welcome — this is your first entry."),
        ]
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([MoltLogEntry].self, from: data) {
            entries = decoded
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}

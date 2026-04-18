import Foundation
import Combine
import AppKit

// MARK: - ShortcutService

final class ShortcutService: ObservableObject {
    @Published private(set) var shortcuts: [Shortcut] = []
    @Published var selectedCategoryID: String = "all"

    private let saveKey = "shortcuthub.shortcuts"
    private let saveURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = support.appendingPathComponent("ShortcutHub", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        saveURL = dir.appendingPathComponent("shortcuts.json")
        load()
    }

    // MARK: - CRUD

    func add(_ shortcut: Shortcut) {
        shortcuts.append(shortcut)
        save()
    }

    func update(_ shortcut: Shortcut) {
        guard let idx = shortcuts.firstIndex(where: { $0.id == shortcut.id }) else { return }
        shortcuts[idx] = shortcut
        save()
    }

    func delete(_ shortcut: Shortcut) {
        shortcuts.removeAll { $0.id == shortcut.id }
        save()
    }

    func toggleEnabled(_ shortcut: Shortcut) {
        guard let idx = shortcuts.firstIndex(where: { $0.id == shortcut.id }) else { return }
        shortcuts[idx].isEnabled.toggle()
        save()
    }

    // MARK: - Filtering

    func filtered(categoryID: String, searchText: String) -> [Shortcut] {
        var result = shortcuts

        if categoryID != "all" {
            result = result.filter { $0.categoryID == categoryID }
        }

        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q)
                || $0.description.lowercased().contains(q)
                || $0.key.lowercased().contains(q)
                || $0.keysDisplay.lowercased().contains(q)
            }
        }

        return result
    }

    func count(for categoryID: String) -> Int {
        categoryID == "all"
            ? shortcuts.count
            : shortcuts.filter { $0.categoryID == categoryID }.count
    }

    func enabledCount(for categoryID: String) -> Int {
        (categoryID == "all" ? shortcuts : shortcuts.filter { $0.categoryID == categoryID })
            .filter { $0.isEnabled }.count
    }

    // MARK: - System Settings

    func openSystemKeyboardSettings() {
        NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.keyboard")!
        )
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(shortcuts)
            try data.write(to: saveURL)
        } catch {
            print("ShortcutService save error: \(error)")
        }
    }

    private func load() {
        var loaded: [Shortcut] = []

        if let data = try? Data(contentsOf: saveURL),
           let decoded = try? JSONDecoder().decode([Shortcut].self, from: data) {
            loaded = decoded
        }

        // Merge builtins: add any builtins not already saved
        let existingIDs = Set(loaded.map { $0.name + $0.categoryID })
        let newBuiltins = BuiltinShortcuts.all.filter {
            !existingIDs.contains($0.name + $0.categoryID)
        }
        loaded += newBuiltins

        // Keep user's custom shortcuts
        shortcuts = loaded
    }

    // MARK: - Reset

    func resetToDefaults() {
        shortcuts = BuiltinShortcuts.all
        save()
    }
}

import Foundation
import AppKit
import ApplicationServices

// MARK: - InstalledApp

struct InstalledApp: Identifiable, Hashable, Sendable {
    let id: String          // bundle identifier
    let name: String
    let bundleID: String
    let url: URL

    static func == (lhs: InstalledApp, rhs: InstalledApp) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - AppScanner

final class AppScanner: ObservableObject {
    @Published var installedApps: [InstalledApp] = []
    @Published var isScanning = false
    @Published var scanProgress: String = ""
    @Published var scannedResults: [String: [Shortcut]] = [:]   // appName → shortcuts
    @Published var hasAXPermission: Bool = false

    init() {
        hasAXPermission = AXIsProcessTrusted()
    }

    // MARK: - Public API

    func requestAXPermission() {
        let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(opts)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hasAXPermission = AXIsProcessTrusted()
        }
    }

    func scanInstalledApps() {
        isScanning = true
        scanProgress = "正在扫描已安装应用…"
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let apps = self.findInstalledApps()
            await MainActor.run {
                self.installedApps = apps
                self.isScanning = false
                self.scanProgress = "找到 \(apps.count) 个应用"
            }
        }
    }

    func readShortcuts(from apps: [InstalledApp]) {
        guard AXIsProcessTrusted() else {
            requestAXPermission()
            return
        }
        isScanning = true
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            var batch: [String: [Shortcut]] = [:]
            for app in apps {
                await MainActor.run { self.scanProgress = "读取 \(app.name) 的快捷键…" }
                let shorts = self.extractMenuShortcuts(from: app)
                if !shorts.isEmpty { batch[app.name] = shorts }
            }
            let total = batch.values.flatMap { $0 }.count
            await MainActor.run {
                self.scannedResults.merge(batch) { _, new in new }
                self.isScanning = false
                self.scanProgress = batch.isEmpty
                    ? "未发现快捷键（应用需在运行中）"
                    : "完成！共发现 \(total) 个快捷键"
            }
        }
    }

    func clearResults() {
        scannedResults = [:]
        scanProgress = ""
    }

    // MARK: - App Discovery

    private func findInstalledApps() -> [InstalledApp] {
        let searchDirs: [URL] = [
            URL(fileURLWithPath: "/Applications"),
            URL(fileURLWithPath: "/System/Applications"),
            FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Applications"),
        ]
        var seen = Set<String>()
        var apps: [InstalledApp] = []
        let fm = FileManager.default

        for dir in searchDirs {
            let contents = (try? fm.contentsOfDirectory(
                at: dir,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )) ?? []

            for url in contents where url.pathExtension == "app" {
                guard let bundle = Bundle(url: url) else { continue }
                let bundleID = bundle.bundleIdentifier ?? url.deletingPathExtension().lastPathComponent
                guard !seen.contains(bundleID) else { continue }
                seen.insert(bundleID)
                let name =
                    (bundle.infoDictionary?["CFBundleDisplayName"] as? String) ??
                    (bundle.infoDictionary?["CFBundleName"] as? String) ??
                    url.deletingPathExtension().lastPathComponent
                apps.append(InstalledApp(id: bundleID, name: name, bundleID: bundleID, url: url))
            }
        }
        return apps.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    // MARK: - AX Menu Reading

    private func extractMenuShortcuts(from app: InstalledApp) -> [Shortcut] {
        guard let running = NSWorkspace.shared.runningApplications
                .first(where: { $0.bundleIdentifier == app.bundleID }) else { return [] }

        let appElement = AXUIElementCreateApplication(running.processIdentifier)
        var menuBarRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(appElement, kAXMenuBarAttribute as CFString, &menuBarRef) == .success,
              let menuBarRef else { return [] }

        let catID = categoryID(for: app)
        var shortcuts: [Shortcut] = []
        traverseMenu(menuBarRef as! AXUIElement, path: [], categoryID: catID, into: &shortcuts, depth: 0)
        return shortcuts
    }

    private func traverseMenu(_ element: AXUIElement, path: [String], categoryID: String,
                               into shortcuts: inout [Shortcut], depth: Int) {
        guard depth < 7 else { return }

        var childRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childRef) == .success,
              let children = childRef as? [AXUIElement] else { return }

        for child in children {
            let title = axString(child, kAXTitleAttribute).trimmingCharacters(in: .whitespaces)
            let cmdChar = axString(child, kAXMenuItemCmdCharAttribute)
            let modFlags = axInt(child, kAXMenuItemCmdModifiersAttribute)
            let vkey = axOptionalInt(child, kAXMenuItemCmdVirtualKeyAttribute)

            if !cmdChar.isEmpty, !title.isEmpty {
                let modifiers = modifiersFromFlags(modFlags)
                let displayKey = resolveKey(cmdChar: cmdChar, vkey: vkey)
                let breadcrumb = (path + [title]).joined(separator: " › ")
                shortcuts.append(Shortcut(
                    name: title,
                    description: breadcrumb,
                    modifiers: modifiers,
                    key: displayKey,
                    categoryID: categoryID,
                    isEnabled: true,
                    isCustom: false
                ))
            }

            let newPath = title.isEmpty ? path : path + [title]
            traverseMenu(child, path: newPath, categoryID: categoryID, into: &shortcuts, depth: depth + 1)
        }
    }

    // MARK: - AX Helpers

    private func axString(_ el: AXUIElement, _ attr: String) -> String {
        var ref: CFTypeRef?
        AXUIElementCopyAttributeValue(el, attr as CFString, &ref)
        return ref as? String ?? ""
    }

    private func axInt(_ el: AXUIElement, _ attr: String) -> Int {
        var ref: CFTypeRef?
        AXUIElementCopyAttributeValue(el, attr as CFString, &ref)
        return ref as? Int ?? 0
    }

    private func axOptionalInt(_ el: AXUIElement, _ attr: String) -> Int? {
        var ref: CFTypeRef?
        guard AXUIElementCopyAttributeValue(el, attr as CFString, &ref) == .success else { return nil }
        return ref as? Int
    }

    // MARK: - Modifier Mapping

    // kAXMenuItemCmdModifiers bit flags:
    //   bit 0 (0x01) = Shift
    //   bit 1 (0x02) = Option
    //   bit 2 (0x04) = Control
    //   bit 3 (0x08) = No Command (command key NOT included)
    private func modifiersFromFlags(_ flags: Int) -> [ModifierKey] {
        var mods: [ModifierKey] = []
        if flags & 0x04 != 0 { mods.append(.control) }
        if flags & 0x02 != 0 { mods.append(.option) }
        if flags & 0x01 != 0 { mods.append(.shift) }
        if flags & 0x08 == 0 { mods.append(.command) }   // command is default unless bit 3 set
        return mods
    }

    // MARK: - Virtual Key → Display String

    private let vkeyMap: [Int: String] = [
        36: "↩", 51: "⌫", 53: "⎋",
        123: "←", 124: "→", 125: "↓", 126: "↑",
        116: "⇞", 121: "⇟", 115: "↖", 119: "↘",
        117: "⌦", 48: "⇥", 49: "Space",
        122: "F1", 120: "F2", 99: "F3", 118: "F4",
        96: "F5", 97: "F6", 98: "F7", 100: "F8",
        101: "F9", 109: "F10", 103: "F11", 111: "F12",
    ]

    private func resolveKey(cmdChar: String, vkey: Int?) -> String {
        if let vkey, let mapped = vkeyMap[vkey] { return mapped }
        let upper = cmdChar.uppercased()
        return upper.isEmpty ? cmdChar : upper
    }

    // MARK: - Category Mapping

    private func categoryID(for app: InstalledApp) -> String {
        switch app.bundleID {
        case "com.apple.finder":                         return "finder"
        case "com.apple.Safari":                         return "safari"
        case "com.apple.Terminal":                       return "terminal"
        case "com.microsoft.VSCode",
             "com.visualstudio.code.oss":               return "vscode"
        case "com.apple.dt.Xcode":                       return "xcode"
        default:
            let n = app.name.lowercased()
            if n.contains("safari")   { return "safari"   }
            if n.contains("terminal") || n.contains("iterm") { return "terminal" }
            if n.contains("code")     { return "vscode"   }
            if n.contains("xcode")    { return "xcode"    }
            if n.contains("finder")   { return "finder"   }
            if app.bundleID.contains("anthropic") { return "claude" }
            return "custom"
        }
    }
}

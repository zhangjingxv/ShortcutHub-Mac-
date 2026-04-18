import Foundation
import AppKit

// MARK: - DocumentExporter

final class DocumentExporter {

    // MARK: - Markdown Generation

    static func generateMarkdown(
        service: ShortcutService,
        scanned: [String: [Shortcut]]
    ) -> String {
        let now = Date()
        let dateStr = now.formatted(date: .long, time: .shortened)

        // Collect built-in groups (skip "all" and empty categories)
        let builtinGroups: [(AppCategory, [Shortcut])] = AppCategory.allCategories
            .filter { $0.id != "all" && $0.id != "custom" }
            .compactMap { cat in
                let shorts = service.filtered(categoryID: cat.id, searchText: "")
                return shorts.isEmpty ? nil : (cat, shorts)
            }

        let customShortcuts = service.filtered(categoryID: "custom", searchText: "")
        let scannedGroups = scanned
            .map { (appName: $0.key, shortcuts: $0.value) }
            .sorted { $0.appName.localizedCompare($1.appName) == .orderedAscending }

        let totalEnabled = service.shortcuts.filter(\.isEnabled).count
        let totalAll     = service.shortcuts.count
        let scannedTotal = scanned.values.flatMap { $0 }.count

        var md = """
        # ⌨️ ShortcutHub — 快捷键完整手册

        > 生成时间：\(dateStr)
        > 管理快捷键：\(totalEnabled) / \(totalAll) 已启用\(scannedTotal > 0 ? "　|　自动扫描发现：\(scannedTotal) 个" : "")

        ---

        ## 目录


        """

        // TOC: built-ins
        for (cat, shorts) in builtinGroups {
            let enabled = shorts.filter(\.isEnabled).count
            md += "- [\(cat.name)](#\(tocAnchor(cat.name))) — \(enabled)/\(shorts.count) 已启用\n"
        }
        if !customShortcuts.isEmpty {
            md += "- [自定义](#自定义) — \(customShortcuts.filter(\.isEnabled).count)/\(customShortcuts.count) 已启用\n"
        }
        if !scannedGroups.isEmpty {
            md += "\n**自动扫描（\(scannedGroups.count) 个应用）**\n\n"
            for g in scannedGroups {
                md += "- [\(g.appName)](#\(tocAnchor(g.appName))) — \(g.shortcuts.count) 个快捷键\n"
            }
        }

        md += "\n---\n\n"

        // Built-in sections
        for (cat, shorts) in builtinGroups {
            md += "## \(cat.name)\n\n"
            md += shortcutTable(shorts)
            md += "\n"
        }

        // Custom shortcuts
        if !customShortcuts.isEmpty {
            md += "## 自定义\n\n"
            md += shortcutTable(customShortcuts)
            md += "\n"
        }

        // Scanned sections
        if !scannedGroups.isEmpty {
            md += "---\n\n## 自动扫描结果\n\n"
            md += "> 以下快捷键由 ShortcutHub 自动读取 macOS 应用菜单生成，包含应用的原生菜单快捷键。\n\n"

            for g in scannedGroups {
                md += "### \(g.appName)\n\n"
                md += shortcutTable(g.shortcuts)
                md += "\n"
            }
        }

        md += "---\n\n*由 [ShortcutHub](https://github.com/zhangjingxv/ShortcutHub-Mac-) 自动生成 · \(dateStr)*\n"
        return md
    }

    // MARK: - Table Formatter

    private static func shortcutTable(_ shortcuts: [Shortcut]) -> String {
        let sorted = shortcuts.sorted {
            if $0.isEnabled != $1.isEnabled { return $0.isEnabled }
            return $0.name.localizedCompare($1.name) == .orderedAscending
        }

        var table = "| 功能 | 快捷键 | 说明 | 状态 |\n"
        table     += "|------|--------|------|:----:|\n"

        for s in sorted {
            let name  = s.isEnabled ? s.name : "~~\(s.name)~~"
            let keys  = "`\(s.keysDisplay)`"
            let desc  = s.description.isEmpty ? "—" : s.description
            let badge = s.isEnabled ? "✅" : "⛔"
            table += "| \(name) | \(keys) | \(desc) | \(badge) |\n"
        }
        return table
    }

    private static func tocAnchor(_ text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .filter { $0.isLetter || $0.isNumber || $0 == "-" }
    }

    // MARK: - Save Panel

    @MainActor
    static func exportToFile(_ content: String) {
        let panel = NSSavePanel()
        panel.title = "导出快捷键文档"
        panel.message = "选择保存位置"
        panel.nameFieldStringValue = filename()
        panel.allowedContentTypes = [.plainText]
        panel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first

        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            NSWorkspace.shared.activateFileViewerSelecting([url])
        } catch {
            let alert = NSAlert()
            alert.messageText = "导出失败"
            alert.informativeText = error.localizedDescription
            alert.runModal()
        }
    }

    private static func filename() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return "ShortcutHub-\(fmt.string(from: Date())).md"
    }
}

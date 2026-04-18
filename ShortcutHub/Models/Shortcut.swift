import Foundation

// MARK: - Modifier Key

enum ModifierKey: String, Codable, CaseIterable, Hashable, Comparable {
    case control = "⌃"
    case option  = "⌥"
    case shift   = "⇧"
    case command = "⌘"
    case fn      = "fn"

    // Sort order matches standard macOS display convention
    private var order: Int {
        switch self {
        case .control: return 0
        case .option:  return 1
        case .shift:   return 2
        case .command: return 3
        case .fn:      return 4
        }
    }

    static func < (lhs: ModifierKey, rhs: ModifierKey) -> Bool {
        lhs.order < rhs.order
    }
}

// MARK: - Shortcut

struct Shortcut: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var modifiers: [ModifierKey]
    var key: String
    var categoryID: String
    var isEnabled: Bool = true
    var isCustom: Bool = false
    var isSystem: Bool = false   // Needs System Settings to truly disable
    var notes: String = ""

    var keysDisplay: String {
        modifiers.sorted().map(\.rawValue).joined() + key
    }
}

// MARK: - App Category

struct AppCategory: Identifiable, Hashable {
    var id: String
    var name: String
    var icon: String  // SF Symbol name
}

extension AppCategory {
    static let allCategories: [AppCategory] = [
        .init(id: "all",     name: "全部",      icon: "keyboard"),
        .init(id: "system",  name: "系统",      icon: "apple.logo"),
        .init(id: "finder",  name: "Finder",    icon: "folder"),
        .init(id: "safari",  name: "Safari",    icon: "safari"),
        .init(id: "terminal",name: "终端",      icon: "terminal"),
        .init(id: "vscode",  name: "VS Code",   icon: "chevron.left.forwardslash.chevron.right"),
        .init(id: "xcode",   name: "Xcode",     icon: "hammer"),
        .init(id: "claude",  name: "Claude Code",icon: "brain"),
        .init(id: "custom",  name: "自定义",    icon: "star"),
    ]
}

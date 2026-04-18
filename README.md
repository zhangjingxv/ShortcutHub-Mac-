# ⌨️ ShortcutHub

A native macOS app for managing, discovering, and documenting keyboard shortcuts across all your apps.

![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-native-green)

---

## Features

### Browse & Manage
- **130+ built-in shortcuts** across System, Finder, Safari, Terminal, VS Code, Xcode, and Claude Code
- Toggle any shortcut **enabled / disabled** — state is saved persistently
- **Search** across all shortcuts by name, description, or key combo
- **Sort** by name, app, or enabled status
- Sidebar navigation by app category with live counts

### Auto-Scan Installed Apps
- Click **「扫描应用」** to scan any running macOS app's menu bar
- Reads shortcuts via the **Accessibility API** — no manual entry required
- Supports all native macOS apps (Finder, Safari, Mail, Xcode, etc.)
- Import discovered shortcuts directly into ShortcutHub

### Export Documentation
- Click **「导出文档」** to generate a **Markdown shortcut manual**
- Includes table of contents, ✅/⛔ status badges, and full descriptions
- Auto-scanned shortcuts appear in a dedicated section
- Saved to your Desktop by default

### Add Custom Shortcuts
- Add your own shortcuts with modifier key checkboxes and free-text key input
- Edit or delete any custom shortcut
- Assign to any app category

---

## Screenshots

> Coming soon

---

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15+
- For app scanning: grant **Accessibility permission** in System Settings → Privacy & Security → Accessibility

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/zhangjingxv/ShortcutHub-Mac.git
cd ShortcutHub-Mac

# Generate Xcode project (requires xcodegen)
brew install xcodegen
xcodegen generate

# Open in Xcode
open ShortcutHub.xcodeproj
```

Press `⌘R` in Xcode to build and run.

---

## Project Structure

```
ShortcutHub/
├── Models/
│   ├── Shortcut.swift          # Data models (Shortcut, AppCategory, ModifierKey)
│   └── BuiltinShortcuts.swift  # 130+ built-in shortcut definitions
├── Services/
│   ├── ShortcutService.swift   # CRUD, persistence, filtering
│   ├── AppScanner.swift        # Accessibility API menu reader
│   └── DocumentExporter.swift  # Markdown document generator
└── Views/
    ├── ContentView.swift        # NavigationSplitView root
    ├── SidebarView.swift        # Category sidebar
    ├── ShortcutListView.swift   # Main shortcut list
    ├── ShortcutRowView.swift    # Row with toggle, keys badge, context menu
    ├── AddShortcutView.swift    # Add / edit sheet
    └── ScanView.swift           # App scanner sheet
```

---

## Built-in App Coverage

| App | Shortcuts |
|-----|-----------|
| macOS System | 30 |
| Finder | 20 |
| Safari | 20 |
| Terminal | 19 |
| VS Code | 23 |
| Xcode | 19 |
| Claude Code | 8 |

---

## License

MIT

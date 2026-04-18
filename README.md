<div align="center">

# ⌨️ ShortcutHub

**Mac 键盘快捷键管理器 · Mac Keyboard Shortcut Manager**

*一站式管理、发现、导出你所有 App 的快捷键*
*Manage, discover, and document shortcuts across all your apps*

---

[![Stars](https://img.shields.io/github/stars/zhangjingxv/ShortcutHub-Mac-?style=for-the-badge&logo=github&color=FFD700&labelColor=1a1a2e)](https://github.com/zhangjingxv/ShortcutHub-Mac-/stargazers)
[![Forks](https://img.shields.io/github/forks/zhangjingxv/ShortcutHub-Mac-?style=for-the-badge&logo=github&color=4FC3F7&labelColor=1a1a2e)](https://github.com/zhangjingxv/ShortcutHub-Mac-/network/members)
[![Watchers](https://img.shields.io/github/watchers/zhangjingxv/ShortcutHub-Mac-?style=for-the-badge&logo=github&color=A5D6A7&labelColor=1a1a2e)](https://github.com/zhangjingxv/ShortcutHub-Mac-/watchers)
[![Release](https://img.shields.io/github/v/release/zhangjingxv/ShortcutHub-Mac-?style=for-the-badge&logo=apple&color=FF6B6B&labelColor=1a1a2e)](https://github.com/zhangjingxv/ShortcutHub-Mac-/releases)
[![Downloads](https://img.shields.io/github/downloads/zhangjingxv/ShortcutHub-Mac-/total?style=for-the-badge&logo=apple&color=CE93D8&labelColor=1a1a2e)](https://github.com/zhangjingxv/ShortcutHub-Mac-/releases)

[![macOS](https://img.shields.io/badge/macOS-13.0%2B-999999?style=flat-square&logo=apple)](https://www.apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-0070C9?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)

</div>

---

## 📦 安装 · Installation

<div align="center">

**[⬇️ 下载 ShortcutHub.dmg · Download DMG](https://github.com/zhangjingxv/ShortcutHub-Mac-/releases/latest)**

</div>

**中文：** 下载 DMG → 打开 → 将 ShortcutHub 拖入 Applications 文件夹 → 启动

**English:** Download the DMG → Open it → Drag ShortcutHub into your Applications folder → Launch

> **首次运行若提示"无法验证开发者"：** 前往 系统设置 → 隐私与安全性 → 点击「仍然打开」
>
> **If macOS says "cannot verify developer":** Go to System Settings → Privacy & Security → click "Open Anyway"

---

## ✨ 功能 · Features

### 🗂 浏览与管理 · Browse & Manage

| 中文 | English |
|------|---------|
| **130+ 内置快捷键**，覆盖 7 款主流 App | **130+ built-in shortcuts** for 7 major apps |
| 每个快捷键可独立**启用 / 禁用**，状态持久保存 | **Toggle** any shortcut on/off — state is saved |
| 按名称、应用、状态**排序** | **Sort** by name, app, or enabled state |
| 实时**搜索**，按名称、说明或按键筛选 | Real-time **search** by name, description, or key |
| 侧边栏按应用**分类导航**，显示启用数量 | **Sidebar navigation** by app with live counts |
| 右键**上下文菜单**，快速操作 | **Context menu** for quick actions |

### 🔍 自动扫描 · Auto-Scan

| 中文 | English |
|------|---------|
| 点击「**扫描应用**」，一键读取任意 Mac 应用的菜单快捷键 | Click **"扫描应用"** to read shortcuts from any running app |
| 基于 **Accessibility API** 遍历完整菜单树（最深 7 层） | Uses **Accessibility API** to traverse the full menu tree |
| 自动识别 Finder / Safari / Terminal / VS Code / Xcode | Auto-maps apps to correct category |
| 扫描结果可直接**导入**到 ShortcutHub 数据库 | **Import** discovered shortcuts into ShortcutHub |
| 绿点 = 正在运行，灰点 = 未运行 | Green dot = running, gray dot = not running |

### 📄 导出文档 · Export Docs

| 中文 | English |
|------|---------|
| 一键导出 **Markdown 快捷键手册** | One-click export of a **Markdown shortcut manual** |
| 含目录、✅/⛔ 状态徽章、完整描述 | Includes TOC, ✅/⛔ status badges, full descriptions |
| 内置快捷键 + 扫描快捷键统一输出 | Combines built-in and scanned shortcuts |
| 默认保存到桌面，导出后自动在 Finder 中定位 | Saves to Desktop, auto-reveals in Finder |

### ➕ 自定义 · Custom Shortcuts

| 中文 | English |
|------|---------|
| 勾选修饰键 ⌘⌃⌥⇧，填写按键名即可添加 | Check modifiers ⌘⌃⌥⇧ + type a key to add |
| 支持编辑和删除自定义快捷键 | Edit and delete custom shortcuts |
| 可分配到任意 App 分类 | Assign to any app category |

---

## 🖥 内置应用覆盖 · Built-in Coverage

<div align="center">

| App | 快捷键数 · Count |
|:---:|:---:|
| 🍎 macOS 系统 | 30 |
| 📁 Finder | 20 |
| 🌐 Safari | 20 |
| ⬛ 终端 Terminal | 19 |
| 🔷 VS Code | 23 |
| 🔨 Xcode | 19 |
| 🤖 Claude Code | 8 |
| **合计 Total** | **139** |

</div>

---

## 🚀 快速开始（开发者）· Getting Started (Developer)

```bash
# 克隆仓库 · Clone
git clone https://github.com/zhangjingxv/ShortcutHub-Mac-.git
cd ShortcutHub-Mac-

# 安装 xcodegen（如未安装）· Install xcodegen
brew install xcodegen

# 生成 Xcode 项目 · Generate Xcode project
xcodegen generate

# 用 Xcode 打开 · Open in Xcode
open ShortcutHub.xcodeproj
```

在 Xcode 中按 `⌘R` 编译并运行。
Press `⌘R` in Xcode to build and run.

### 使用自动扫描功能 · Using Auto-Scan

1. **中文：** 启动 App → 工具栏点「扫描应用」→ 首次使用需授权辅助功能权限（系统设置 → 隐私与安全性 → 辅助功能）→ 选择应用 → 开始扫描
2. **English:** Launch app → click "扫描应用" in toolbar → grant Accessibility permission on first use (System Settings → Privacy & Security → Accessibility) → select apps → start scan

---

## 📁 项目结构 · Project Structure

```
ShortcutHub/
├── Models/
│   ├── Shortcut.swift           # 数据模型 · Data models
│   └── BuiltinShortcuts.swift   # 139 条内置快捷键 · 139 built-in shortcuts
├── Services/
│   ├── ShortcutService.swift    # 增删改查、持久化 · CRUD & persistence
│   ├── AppScanner.swift         # Accessibility API 菜单读取 · Menu reader
│   └── DocumentExporter.swift   # Markdown 文档生成 · Markdown generator
└── Views/
    ├── ContentView.swift         # 根视图 · Root view
    ├── SidebarView.swift         # 分类侧边栏 · Category sidebar
    ├── ShortcutListView.swift    # 快捷键列表 · Shortcut list
    ├── ShortcutRowView.swift     # 行组件（含 Toggle）· Row with toggle
    ├── AddShortcutView.swift     # 添加/编辑弹窗 · Add/edit sheet
    └── ScanView.swift            # 扫描应用弹窗 · Scanner sheet
```

---

## 🤝 贡献 · Contributing

欢迎提交 Issue 和 Pull Request！
Issues and PRs are welcome!

1. Fork 本仓库 · Fork the repo
2. 创建分支 `git checkout -b feat/your-feature`
3. 提交改动 `git commit -m "feat: ..."`
4. 推送分支 `git push origin feat/your-feature`
5. 发起 Pull Request

---

## 📄 许可 · License

[MIT License](LICENSE) © 2026 zhangjingxv

---

<div align="center">

**如果觉得有用，请点一个 ⭐ Star！**
**If you find this useful, please give it a ⭐ Star!**

[![Star History Chart](https://api.star-history.com/svg?repos=zhangjingxv/ShortcutHub-Mac-&type=Date)](https://star-history.com/#zhangjingxv/ShortcutHub-Mac-&Date)

</div>

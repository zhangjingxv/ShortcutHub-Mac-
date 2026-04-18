import SwiftUI

struct ShortcutListView: View {
    @EnvironmentObject var service: ShortcutService
    let categoryID: String
    @Binding var searchText: String
    var onEdit: (Shortcut) -> Void

    @State private var sortOrder: SortOrder = .name

    private var shortcuts: [Shortcut] {
        let raw = service.filtered(categoryID: categoryID, searchText: searchText)
        switch sortOrder {
        case .name:    return raw.sorted { $0.name < $1.name }
        case .app:     return raw.sorted { $0.categoryID < $1.categoryID }
        case .enabled: return raw.sorted { ($0.isEnabled ? 0 : 1) < ($1.isEnabled ? 0 : 1) }
        }
    }

    private var categoryTitle: String {
        AppCategory.allCategories.first { $0.id == categoryID }?.name ?? "快捷键"
    }

    var body: some View {
        Group {
            if shortcuts.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .navigationTitle(categoryTitle)
        .navigationSubtitle("\(service.enabledCount(for: categoryID)) / \(service.count(for: categoryID)) 已启用")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("排序", selection: $sortOrder) {
                    Label("按名称", systemImage: "textformat.abc").tag(SortOrder.name)
                    Label("按应用", systemImage: "square.grid.2x2").tag(SortOrder.app)
                    Label("按状态", systemImage: "checkmark.circle").tag(SortOrder.enabled)
                }
                .pickerStyle(.menu)
                .help("排序方式")
            }

            ToolbarItem(placement: .automatic) {
                Button {
                    service.openSystemKeyboardSettings()
                } label: {
                    Label("系统键盘设置", systemImage: "keyboard.badge.ellipsis")
                }
                .help("打开系统键盘设置")
            }
        }
    }

    // MARK: - List

    private var list: some View {
        List {
            ForEach(shortcuts) { shortcut in
                ShortcutRowView(shortcut: shortcut, onEdit: onEdit)
                    .listRowSeparator(.visible)
                    .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
        }
        .listStyle(.inset)
        .animation(.default, value: shortcuts.map(\.id))
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: searchText.isEmpty ? "keyboard" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            if searchText.isEmpty {
                Text("暂无快捷键")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("点击右上角 + 按钮添加自定义快捷键")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
            } else {
                Text("未找到匹配结果")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("尝试不同的关键词")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Sort

    enum SortOrder {
        case name, app, enabled
    }
}

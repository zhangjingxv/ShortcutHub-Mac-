import SwiftUI

struct ShortcutRowView: View {
    @EnvironmentObject var service: ShortcutService
    let shortcut: Shortcut
    var onEdit: (Shortcut) -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            // Enable/Disable toggle
            Toggle("", isOn: Binding(
                get: { shortcut.isEnabled },
                set: { _ in service.toggleEnabled(shortcut) }
            ))
            .toggleStyle(.switch)
            .labelsHidden()
            .scaleEffect(0.8)
            .help(shortcut.isEnabled ? "点击禁用此快捷键" : "点击启用此快捷键")

            // Info
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(shortcut.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(shortcut.isEnabled ? .primary : .secondary)

                    if shortcut.isSystem {
                        Label("系统级", systemImage: "apple.logo")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.secondary.opacity(0.12), in: Capsule())
                    }

                    if shortcut.isCustom {
                        Label("自定义", systemImage: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.12), in: Capsule())
                    }
                }

                Text(shortcut.description)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }

            Spacer()

            // Keys display
            KeyBadgeView(keys: shortcut.keysDisplay)
                .opacity(shortcut.isEnabled ? 1 : 0.4)

            // Actions (shown on hover)
            if isHovered {
                HStack(spacing: 4) {
                    Button {
                        onEdit(shortcut)
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("编辑快捷键")

                    if shortcut.isCustom {
                        Button(role: .destructive) {
                            service.delete(shortcut)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red.opacity(0.7))
                        }
                        .buttonStyle(.plain)
                        .help("删除快捷键")
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .contextMenu {
            Button {
                onEdit(shortcut)
            } label: {
                Label("编辑", systemImage: "pencil")
            }

            Button {
                service.toggleEnabled(shortcut)
            } label: {
                Label(
                    shortcut.isEnabled ? "禁用此快捷键" : "启用此快捷键",
                    systemImage: shortcut.isEnabled ? "xmark.circle" : "checkmark.circle"
                )
            }

            if shortcut.isSystem {
                Divider()
                Button {
                    service.openSystemKeyboardSettings()
                } label: {
                    Label("在系统设置中修改", systemImage: "gear")
                }
            }

            if shortcut.isCustom {
                Divider()
                Button(role: .destructive) {
                    service.delete(shortcut)
                } label: {
                    Label("删除", systemImage: "trash")
                }
            }
        }
    }
}

// MARK: - KeyBadgeView

struct KeyBadgeView: View {
    let keys: String

    var body: some View {
        Text(keys)
            .font(.system(.callout, design: .monospaced))
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.08), radius: 1, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(.separator, lineWidth: 1)
                    )
            )
            .foregroundStyle(.primary)
    }
}

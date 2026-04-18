import SwiftUI

// MARK: - Mode

enum AddShortcutMode {
    case add
    case edit(Shortcut)
}

// MARK: - AddShortcutView

struct AddShortcutView: View {
    @EnvironmentObject var service: ShortcutService
    @Environment(\.dismiss) private var dismiss

    let mode: AddShortcutMode

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var key: String = ""
    @State private var selectedModifiers: Set<ModifierKey> = []
    @State private var categoryID: String = "custom"
    @State private var notes: String = ""
    @State private var isEnabled: Bool = true

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var existingID: UUID? {
        if case .edit(let s) = mode { return s.id }
        return nil
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !key.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(isEditing ? "编辑快捷键" : "添加快捷键")
                    .font(.headline)
                Spacer()
                Button("取消") { dismiss() }
                    .keyboardShortcut(.escape)
                Button(isEditing ? "保存" : "添加") {
                    commit()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValid)
                .keyboardShortcut(.return, modifiers: .command)
            }
            .padding()

            Divider()

            Form {
                Section("基本信息") {
                    TextField("名称 *", text: $name)
                    TextField("说明", text: $description)
                }

                Section("快捷键组合") {
                    // Modifier checkboxes
                    HStack(spacing: 12) {
                        ForEach(ModifierKey.allCases, id: \.self) { mod in
                            Toggle(mod.rawValue, isOn: Binding(
                                get: { selectedModifiers.contains(mod) },
                                set: { on in
                                    if on { selectedModifiers.insert(mod) }
                                    else  { selectedModifiers.remove(mod) }
                                }
                            ))
                            .toggleStyle(.button)
                            .font(.system(.body, design: .monospaced))
                        }
                    }

                    HStack {
                        TextField("按键 (例如：A, Space, F1, ↑)", text: $key)
                        if !key.isEmpty {
                            Spacer()
                            KeyBadgeView(
                                keys: selectedModifiers.sorted().map(\.rawValue).joined() + key
                            )
                        }
                    }
                }

                Section("分类") {
                    Picker("所属应用", selection: $categoryID) {
                        ForEach(AppCategory.allCategories.filter { $0.id != "all" }) { cat in
                            Label(cat.name, systemImage: cat.icon).tag(cat.id)
                        }
                    }
                }

                Section("其他") {
                    Toggle("启用此快捷键", isOn: $isEnabled)
                    TextField("备注", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .formStyle(.grouped)
        }
        .frame(width: 480)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear(perform: prefill)
    }

    // MARK: - Logic

    private func prefill() {
        guard case .edit(let s) = mode else { return }
        name = s.name
        description = s.description
        key = s.key
        selectedModifiers = Set(s.modifiers)
        categoryID = s.categoryID
        notes = s.notes
        isEnabled = s.isEnabled
    }

    private func commit() {
        var shortcut = Shortcut(
            name: name.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            modifiers: selectedModifiers.sorted(),
            key: key.trimmingCharacters(in: .whitespaces),
            categoryID: categoryID,
            isEnabled: isEnabled,
            isCustom: true,
            notes: notes
        )

        if let existingID {
            shortcut.id = existingID
            service.update(shortcut)
        } else {
            service.add(shortcut)
        }

        dismiss()
    }
}

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var service: ShortcutService
    @Binding var selectedCategoryID: String

    var body: some View {
        List(selection: $selectedCategoryID) {
            ForEach(AppCategory.allCategories) { category in
                SidebarRow(category: category, selectedID: $selectedCategoryID)
                    .tag(category.id)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("ShortcutHub")
    }
}

// MARK: - SidebarRow

private struct SidebarRow: View {
    @EnvironmentObject var service: ShortcutService
    let category: AppCategory
    @Binding var selectedID: String

    var isSelected: Bool { selectedID == category.id }

    var total: Int   { service.count(for: category.id) }
    var enabled: Int { service.enabledCount(for: category.id) }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: category.icon)
                .frame(width: 20)
                .foregroundStyle(iconColor)

            Text(category.name)
                .font(.body)

            Spacer()

            if total > 0 {
                Text("\(enabled)")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.secondary.opacity(0.15), in: Capsule())
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onTapGesture { selectedID = category.id }
    }

    private var iconColor: Color {
        switch category.id {
        case "all":      return .accentColor
        case "system":   return .primary
        case "finder":   return .blue
        case "safari":   return .blue
        case "terminal": return .green
        case "vscode":   return .blue
        case "xcode":    return .cyan
        case "claude":   return .orange
        case "custom":   return .yellow
        default:         return .accentColor
        }
    }
}

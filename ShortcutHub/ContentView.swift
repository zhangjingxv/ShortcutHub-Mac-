import SwiftUI

struct ContentView: View {
    @EnvironmentObject var service: ShortcutService
    @State private var selectedCategoryID: String = "all"
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var editingShortcut: Shortcut? = nil

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView(selectedCategoryID: $selectedCategoryID)
                .navigationSplitViewColumnWidth(min: 180, ideal: 210, max: 240)
        } detail: {
            ShortcutListView(
                categoryID: selectedCategoryID,
                searchText: $searchText,
                onEdit: { editingShortcut = $0 }
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Label("添加快捷键", systemImage: "plus.circle.fill")
                }
                .help("添加自定义快捷键 (⌘⇧N)")
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "搜索快捷键…")
        .sheet(isPresented: $showAddSheet) {
            AddShortcutView(mode: .add)
        }
        .sheet(item: $editingShortcut) { shortcut in
            AddShortcutView(mode: .edit(shortcut))
        }
        .onReceive(NotificationCenter.default.publisher(for: .showAddShortcut)) { _ in
            showAddSheet = true
        }
    }
}

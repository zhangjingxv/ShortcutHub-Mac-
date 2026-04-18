import SwiftUI

@main
struct ShortcutHubApp: App {
    @StateObject private var service = ShortcutService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(service)
                .frame(minWidth: 900, minHeight: 580)
        }
        .windowStyle(.automatic)
        .defaultSize(width: 1100, height: 700)
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandMenu("快捷键") {
                Button("添加自定义快捷键") {
                    NotificationCenter.default.post(name: .showAddShortcut, object: nil)
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])

                Divider()

                Button("前往系统键盘设置") {
                    NSWorkspace.shared.open(
                        URL(string: "x-apple.systempreferences:com.apple.preference.keyboard")!
                    )
                }
            }
        }
    }
}

extension Notification.Name {
    static let showAddShortcut = Notification.Name("showAddShortcut")
}

import SwiftUI
import AppKit

// MARK: - ScanView

struct ScanView: View {
    @EnvironmentObject var service: ShortcutService
    @StateObject private var scanner = AppScanner()
    @Environment(\.dismiss) private var dismiss

    @State private var selectedIDs: Set<String> = []
    @State private var searchText = ""
    @State private var showOnlyRunning = true
    @State private var hasScanned = false

    private var runningIDs: Set<String> {
        Set(NSWorkspace.shared.runningApplications.compactMap(\.bundleIdentifier))
    }

    private var filteredApps: [InstalledApp] {
        var apps = scanner.installedApps
        if showOnlyRunning { apps = apps.filter { runningIDs.contains($0.bundleID) } }
        if !searchText.isEmpty {
            apps = apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return apps
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar

            if !scanner.hasAXPermission {
                permissionBanner
            }

            Divider()

            HStack(spacing: 0) {
                appListPanel
                Divider()
                resultsPanel
            }

            Divider()
            footerBar
        }
        .frame(width: 840, height: 580)
        .task { scanner.scanInstalledApps() }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "keyboard.badge.eye")
                .font(.title2)
                .foregroundStyle(.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("自动扫描应用快捷键")
                    .font(.headline)
                Text("读取 macOS 应用菜单栏，自动发现所有快捷键（需应用正在运行）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("关闭") { dismiss() }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    // MARK: - Permission Banner

    private var permissionBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.shield.fill")
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 1) {
                Text("需要辅助功能权限才能读取其他应用的菜单")
                    .fontWeight(.medium)
                Text("系统设置 › 隐私与安全性 › 辅助功能 › 授权 ShortcutHub")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("打开系统设置") {
                scanner.requestAXPermission()
                NSWorkspace.shared.open(
                    URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
                )
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.orange.opacity(0.08))
    }

    // MARK: - App List Panel

    private var appListPanel: some View {
        VStack(spacing: 0) {
            // Search + filter toolbar
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("搜索应用…", text: $searchText).textFieldStyle(.plain)
            }
            .padding(8)
            .background(.background)

            HStack {
                Toggle("仅显示运行中", isOn: $showOnlyRunning)
                    .toggleStyle(.checkbox)
                    .font(.caption)
                Spacer()
                Button("全选运行中") {
                    selectedIDs = Set(filteredApps.filter { runningIDs.contains($0.bundleID) }.map(\.id))
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundStyle(.accent)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 4)

            Divider()

            if scanner.isScanning && scanner.installedApps.isEmpty {
                ProgressView("扫描应用中…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredApps, id: \.id, selection: $selectedIDs) { app in
                    AppRowItem(app: app, isRunning: runningIDs.contains(app.bundleID))
                        .tag(app.id)
                }
                .listStyle(.sidebar)
            }

            Divider()
            HStack {
                Text("\(selectedIDs.count) 已选 · \(filteredApps.filter { runningIDs.contains($0.bundleID) }.count) 运行中")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Spacer()
            }
            .padding(6)
        }
        .frame(width: 260)
    }

    // MARK: - Results Panel

    private var resultsPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Text("扫描结果")
                    .font(.headline)
                Spacer()
                if !scanner.scannedResults.isEmpty {
                    let total = scanner.scannedResults.values.flatMap { $0 }.count
                    Text("\(scanner.scannedResults.count) 个应用  ·  \(total) 个快捷键")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Button {
                        scanner.clearResults()
                        hasScanned = false
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("清空结果")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            Divider()

            if scanner.isScanning {
                VStack(spacing: 14) {
                    ProgressView().scaleEffect(1.2)
                    Text(scanner.scanProgress)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if scanner.scannedResults.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: hasScanned ? "questionmark.app" : "keyboard.badge.eye")
                        .font(.system(size: 44))
                        .foregroundStyle(.tertiary)
                    Text(hasScanned ? "选中的应用未发现快捷键" : "选择左侧应用后点击「开始扫描」")
                        .foregroundStyle(.secondary)
                    if hasScanned {
                        Text("提示：仅支持使用原生 macOS 菜单栏的应用")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                resultsList
            }
        }
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(Array(scanner.scannedResults.keys.sorted()), id: \.self) { appName in
                    let shortcuts = scanner.scannedResults[appName] ?? []
                    Section {
                        ForEach(shortcuts.sorted(by: { $0.name < $1.name })) { sc in
                            HStack {
                                Text(sc.name)
                                    .font(.callout)
                                    .lineLimit(1)
                                Spacer()
                                KeyBadgeView(keys: sc.keysDisplay)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            Divider().padding(.leading, 16)
                        }
                    } header: {
                        HStack {
                            Text(appName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(shortcuts.count)")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.secondary.opacity(0.15), in: Capsule())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.background)
                    }
                }
            }
        }
    }

    // MARK: - Footer

    private var footerBar: some View {
        HStack(spacing: 10) {
            if !scanner.scanProgress.isEmpty, !scanner.isScanning {
                Image(systemName: scanner.scannedResults.isEmpty ? "exclamationmark.circle" : "checkmark.circle.fill")
                    .foregroundStyle(scanner.scannedResults.isEmpty ? .secondary : .green)
                Text(scanner.scanProgress)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Button {
                exportDoc()
            } label: {
                Label("导出文档", systemImage: "doc.text")
            }
            .disabled(scanner.scannedResults.isEmpty)
            .help("生成 Markdown 格式的快捷键手册")

            Button {
                importToService()
            } label: {
                Label("导入到 ShortcutHub", systemImage: "tray.and.arrow.down")
            }
            .disabled(scanner.scannedResults.isEmpty)
            .help("将扫描到的快捷键添加到 ShortcutHub 数据库")

            Button {
                scan()
            } label: {
                Label(scanner.isScanning ? "扫描中…" : "开始扫描", systemImage: "arrow.triangle.2.circlepath")
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedIDs.isEmpty || scanner.isScanning)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    // MARK: - Actions

    private func scan() {
        hasScanned = true
        let appsToScan = scanner.installedApps.filter { selectedIDs.contains($0.id) }
        scanner.readShortcuts(from: appsToScan)
    }

    private func exportDoc() {
        let content = DocumentExporter.generateMarkdown(
            service: service,
            scanned: scanner.scannedResults
        )
        DocumentExporter.exportToFile(content)
    }

    private func importToService() {
        let knownIDs = Set(AppCategory.allCategories.map(\.id))
        var added = 0
        for shortcuts in scanner.scannedResults.values {
            for var sc in shortcuts {
                if !knownIDs.contains(sc.categoryID) { sc.categoryID = "custom" }
                let exists = service.shortcuts.contains { $0.name == sc.name && $0.categoryID == sc.categoryID }
                if !exists {
                    service.add(sc)
                    added += 1
                }
            }
        }
        if added > 0 { dismiss() }
    }
}

// MARK: - AppRowItem

private struct AppRowItem: View {
    let app: InstalledApp
    let isRunning: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(nsImage: NSWorkspace.shared.icon(forFile: app.url.path))
                .resizable()
                .frame(width: 22, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 5))

            Text(app.name)
                .font(.callout)
                .lineLimit(1)

            Spacer()

            Circle()
                .fill(isRunning ? Color.green : Color.secondary.opacity(0.3))
                .frame(width: 7, height: 7)
                .help(isRunning ? "正在运行" : "未运行")
        }
        .opacity(isRunning ? 1 : 0.55)
        .padding(.vertical, 1)
    }
}

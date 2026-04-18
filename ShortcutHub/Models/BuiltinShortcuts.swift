import Foundation

// MARK: - Built-in Shortcuts Database

enum BuiltinShortcuts {
    static let all: [Shortcut] = system + finder + safari + terminal + vscode + xcode + claudeCode

    // MARK: System
    static let system: [Shortcut] = [
        s("Spotlight 搜索",     "打开 Spotlight 搜索框",       [.command],          "Space",    "system", isSystem: true),
        s("全屏截图",            "截取整个屏幕并保存",           [.command, .shift],  "3",        "system", isSystem: true),
        s("区域截图",            "截取选定区域并保存",           [.command, .shift],  "4",        "system", isSystem: true),
        s("截图工具栏",          "打开截图工具栏",               [.command, .shift],  "5",        "system", isSystem: true),
        s("录屏",               "开始/停止录制屏幕",            [.command, .shift],  "6",        "system", isSystem: true),
        s("切换应用",            "在打开的应用之间切换",          [.command],          "Tab",      "system", isSystem: true),
        s("切换同应用窗口",       "切换同一应用的多个窗口",        [.command],          "`",        "system"),
        s("调度中心",            "显示所有打开的窗口和桌面",      [.control],          "↑",        "system", isSystem: true),
        s("应用所有窗口",         "显示当前应用的所有窗口",        [.control],          "↓",        "system", isSystem: true),
        s("隐藏当前应用",         "隐藏当前应用的所有窗口",        [.command],          "H",        "system"),
        s("隐藏其他应用",         "隐藏所有其他应用的窗口",        [.command, .option], "H",        "system"),
        s("最小化窗口",          "将当前窗口最小化到 Dock",      [.command],          "M",        "system"),
        s("关闭窗口",            "关闭当前窗口或标签页",          [.command],          "W",        "system"),
        s("退出应用",            "完全退出当前应用",              [.command],          "Q",        "system"),
        s("偏好设置",            "打开当前应用的偏好设置",         [.command],          ",",        "system"),
        s("强制退出",            "打开强制退出应用对话框",         [.command, .option], "Esc",      "system"),
        s("锁定屏幕",            "立即锁定屏幕",                 [.command, .control],"Q",        "system", isSystem: true),
        s("撤销",               "撤销上一步操作",               [.command],          "Z",        "system"),
        s("重做",               "重做已撤销的操作",              [.command, .shift],  "Z",        "system"),
        s("复制",               "复制所选内容",                 [.command],          "C",        "system"),
        s("粘贴",               "粘贴剪贴板内容",               [.command],          "V",        "system"),
        s("剪切",               "剪切所选内容",                 [.command],          "X",        "system"),
        s("全选",               "选择所有内容",                 [.command],          "A",        "system"),
        s("查找",               "在当前文档中搜索",              [.command],          "F",        "system"),
        s("打印",               "打印当前文档",                 [.command],          "P",        "system"),
        s("保存",               "保存当前文档",                 [.command],          "S",        "system"),
        s("另存为",             "将文档保存到新位置",             [.command, .shift],  "S",        "system"),
        s("新建窗口",            "新建应用程序窗口",              [.command],          "N",        "system"),
        s("通知中心",            "显示/隐藏通知中心",             [.control],          "N",        "system", isSystem: true),
        s("切换 Do Not Disturb","开启/关闭勿扰模式",            [.option],           "N",        "system", isSystem: true),
    ]

    // MARK: Finder
    static let finder: [Shortcut] = [
        s("新建 Finder 窗口",   "打开新的 Finder 窗口",         [.command],          "N",        "finder"),
        s("新建文件夹",          "在当前位置创建新文件夹",         [.command, .shift],  "N",        "finder"),
        s("移至废纸篓",          "将选中文件移至废纸篓",          [.command],          "Delete",   "finder"),
        s("清空废纸篓",          "永久删除废纸篓中的文件",         [.command, .shift],  "Delete",   "finder"),
        s("前往文件夹",          "输入路径直接跳转",              [.command, .shift],  "G",        "finder"),
        s("快速查看",            "预览选中的文件",               [],                  "Space",    "finder"),
        s("显示简介",            "查看文件或文件夹详细信息",       [.command],          "I",        "finder"),
        s("复制文件",            "复制选中文件到同一位置",         [.command],          "D",        "finder"),
        s("制作替身",            "为选中文件创建快捷方式",         [.command],          "L",        "finder"),
        s("重命名",             "重命名选中文件",                [],                  "Return",   "finder"),
        s("在新标签页打开",       "在 Finder 新标签页中打开",      [.command],          "T",        "finder"),
        s("连接服务器",          "连接到网络服务器",              [.command],          "K",        "finder"),
        s("显示/隐藏隐藏文件",    "切换隐藏文件的显示状态",         [.command, .shift],  ".",        "finder"),
        s("列表视图",            "切换到列表视图",               [.command],          "2",        "finder"),
        s("图标视图",            "切换到图标视图",               [.command],          "1",        "finder"),
        s("列视图",             "切换到列视图",                 [.command],          "3",        "finder"),
        s("Gallery 视图",       "切换到画廊视图",               [.command],          "4",        "finder"),
        s("前往上一目录",         "返回上一级目录",               [.command],          "↑",        "finder"),
        s("打开选中文件夹",       "进入选中的文件夹",              [.command],          "↓",        "finder"),
        s("弹出磁盘",            "安全弹出外接磁盘",              [.command],          "E",        "finder"),
    ]

    // MARK: Safari
    static let safari: [Shortcut] = [
        s("新建标签页",          "打开新的浏览标签页",            [.command],          "T",        "safari"),
        s("关闭标签页",          "关闭当前标签页",               [.command],          "W",        "safari"),
        s("重新打开关闭标签页",   "恢复最近关闭的标签页",          [.command, .shift],  "T",        "safari"),
        s("刷新页面",            "重新加载当前页面",              [.command],          "R",        "safari"),
        s("强制刷新",            "清除缓存并重新加载",            [.command, .option], "R",        "safari"),
        s("打开地址栏",          "聚焦到地址搜索框",              [.command],          "L",        "safari"),
        s("添加书签",            "将当前页面添加到书签",           [.command],          "D",        "safari"),
        s("后退",               "返回上一页",                   [.command],          "[",        "safari"),
        s("前进",               "前进到下一页",                  [.command],          "]",        "safari"),
        s("页面查找",            "在当前页面内搜索文字",           [.command],          "F",        "safari"),
        s("放大页面",            "放大当前网页内容",              [.command],          "+",        "safari"),
        s("缩小页面",            "缩小当前网页内容",              [.command],          "-",        "safari"),
        s("恢复默认缩放",         "恢复页面到默认缩放比例",         [.command],          "0",        "safari"),
        s("新建窗口",            "打开新的浏览器窗口",             [.command],          "N",        "safari"),
        s("隐私窗口",            "打开新的隐私浏览窗口",           [.command, .shift],  "N",        "safari"),
        s("下载管理器",          "显示下载列表",                 [.command, .option], "L",        "safari"),
        s("书签管理器",          "显示书签边栏",                 [.command],          "B",        "safari"),
        s("开发者工具",          "打开 Web 检查器",              [.command, .option], "I",        "safari"),
        s("切换到下一标签",       "切换到右侧标签页",              [.control],          "Tab",      "safari"),
        s("切换到上一标签",       "切换到左侧标签页",              [.control, .shift],  "Tab",      "safari"),
    ]

    // MARK: Terminal
    static let terminal: [Shortcut] = [
        s("新建标签页",          "在终端打开新标签页",             [.command],          "T",        "terminal"),
        s("新建窗口",            "打开新的终端窗口",              [.command],          "N",        "terminal"),
        s("中断进程",            "发送 SIGINT 信号终止当前命令",   [.control],          "C",        "terminal"),
        s("暂停进程",            "将进程挂起到后台",              [.control],          "Z",        "terminal"),
        s("发送 EOF",           "关闭输入流，退出交互程序",         [.control],          "D",        "terminal"),
        s("跳到行首",            "光标移动到当前行开头",           [.control],          "A",        "terminal"),
        s("跳到行尾",            "光标移动到当前行末尾",           [.control],          "E",        "terminal"),
        s("清屏",               "清除终端所有输出",              [.control],          "L",        "terminal"),
        s("删除到行首",          "删除光标前的所有内容",           [.control],          "U",        "terminal"),
        s("删除到行尾",          "删除光标后的所有内容",           [.control],          "K",        "terminal"),
        s("删除上一个词",         "删除光标前的一个单词",           [.control],          "W",        "terminal"),
        s("上一条命令",          "切换到上一条历史命令",           [],                  "↑",        "terminal"),
        s("下一条命令",          "切换到下一条历史命令",           [],                  "↓",        "terminal"),
        s("历史搜索",            "反向搜索命令历史",              [.control],          "R",        "terminal"),
        s("关闭标签页",          "关闭当前终端标签页",             [.command],          "W",        "terminal"),
        s("复制",               "复制选中的文本",               [.command],          "C",        "terminal"),
        s("粘贴",               "粘贴文本到终端",               [.command],          "V",        "terminal"),
        s("放大字体",            "增大终端字体大小",              [.command],          "+",        "terminal"),
        s("缩小字体",            "减小终端字体大小",              [.command],          "-",        "terminal"),
    ]

    // MARK: VS Code
    static let vscode: [Shortcut] = [
        s("命令面板",            "打开命令面板",                 [.command, .shift],  "P",        "vscode"),
        s("快速打开文件",         "按名称搜索并打开文件",           [.command],          "P",        "vscode"),
        s("切换终端",            "显示/隐藏集成终端",             [.command],          "`",        "vscode"),
        s("注释/取消注释行",      "快速注释或取消注释选中行",       [.command],          "/",        "vscode"),
        s("格式化文档",          "对整个文件进行代码格式化",        [.option, .shift],   "F",        "vscode"),
        s("全局搜索",            "在所有文件中搜索文本",           [.command, .shift],  "F",        "vscode"),
        s("切换侧边栏",          "显示/隐藏左侧侧边栏",           [.command],          "B",        "vscode"),
        s("切换面板",            "显示/隐藏底部面板",             [.command],          "J",        "vscode"),
        s("资源管理器",          "打开文件资源管理器侧边栏",        [.command, .shift],  "E",        "vscode"),
        s("源代码管理",          "打开 Git 控制面板",             [.command, .shift],  "G",        "vscode"),
        s("全局替换",            "在所有文件中搜索并替换",          [.command, .shift],  "H",        "vscode"),
        s("多光标选择",          "在下一处匹配位置添加光标",         [.command],          "D",        "vscode"),
        s("复制行向上",          "向上复制当前行",               [.option, .shift],   "↑",        "vscode"),
        s("复制行向下",          "向下复制当前行",               [.option, .shift],   "↓",        "vscode"),
        s("移动行向上",          "将当前行上移一行",              [.option],           "↑",        "vscode"),
        s("移动行向下",          "将当前行下移一行",              [.option],           "↓",        "vscode"),
        s("转到定义",            "跳转到符号定义处",              [.command],          "F12",      "vscode"),
        s("返回",               "返回上一个编辑位置",             [.control],          "-",        "vscode"),
        s("快速修复",            "显示代码快速修复建议",           [.command],          ".",        "vscode"),
        s("新建终端",            "新建一个集成终端实例",           [.control, .shift],  "`",        "vscode"),
        s("关闭当前编辑器",       "关闭当前标签页",               [.command],          "W",        "vscode"),
        s("切换到下一编辑器",      "切换到右侧标签页",              [.command, .option], "→",        "vscode"),
        s("切换到上一编辑器",      "切换到左侧标签页",              [.command, .option], "←",        "vscode"),
    ]

    // MARK: Xcode
    static let xcode: [Shortcut] = [
        s("编译",               "编译当前项目",                 [.command],          "B",        "xcode"),
        s("运行",               "编译并运行项目",               [.command],          "R",        "xcode"),
        s("停止",               "停止运行中的应用",              [.command],          ".",        "xcode"),
        s("测试",               "运行所有测试",                 [.command],          "U",        "xcode"),
        s("清理",               "清理编译产物",                 [.command, .shift],  "K",        "xcode"),
        s("注释/取消注释",        "快速注释选中代码",              [.command],          "/",        "xcode"),
        s("格式化代码",          "自动对齐和格式化选中代码",        [.control],          "I",        "xcode"),
        s("快速打开",            "按名称搜索并打开文件或符号",      [.command, .shift],  "O",        "xcode"),
        s("跳到定义",            "跳转到符号的定义位置",           [.command],          "↓",        "xcode"),
        s("显示问题导航器",       "显示编译警告和错误列表",          [.command],          "4",        "xcode"),
        s("显示项目导航器",       "显示项目文件树",               [.command],          "1",        "xcode"),
        s("查找并替换",          "在文件中搜索并替换文本",          [.command],          "H",        "xcode"),
        s("全局搜索",            "在整个项目中搜索",              [.command, .shift],  "F",        "xcode"),
        s("添加断点",            "在当前行添加/移除断点",           [.command],          "\\",       "xcode"),
        s("继续执行",            "调试时继续运行到下一断点",         [.command, .control],"Y",        "xcode"),
        s("单步执行",            "调试时单步跳过函数",             [.command, .shift],  "O",        "xcode"),
        s("折叠/展开方法",        "折叠或展开代码块",              [.command, .option], "←",        "xcode"),
        s("折叠所有方法",         "折叠文件中所有方法",             [.command, .option], "⇧",        "xcode"),
        s("切换文档/代码",        "在文档注释和代码间切换",          [.command, .option], "/",        "xcode"),
    ]

    // MARK: Claude Code
    static let claudeCode: [Shortcut] = [
        s("提交消息",            "发送当前输入的消息",             [.command],          "Return",   "claude"),
        s("换行",               "在输入框中插入换行符",            [.shift],            "Return",   "claude"),
        s("清除对话",            "清空当前对话历史",              [.command],          "K",        "claude"),
        s("斜杠命令",            "输入 / 触发命令菜单",           [],                  "/",        "claude"),
        s("撤销",               "撤销上一步输入",               [.command],          "Z",        "claude"),
        s("中断生成",            "停止当前正在生成的响应",          [.command],          ".",        "claude"),
        s("打开设置",            "打开 Claude Code 设置",         [.command],          ",",        "claude"),
        s("新建会话",            "开始一个全新的对话会话",          [.command],          "N",        "claude"),
    ]

    // MARK: Helper

    private static func s(
        _ name: String,
        _ description: String,
        _ modifiers: [ModifierKey],
        _ key: String,
        _ categoryID: String,
        isSystem: Bool = false
    ) -> Shortcut {
        Shortcut(
            name: name,
            description: description,
            modifiers: modifiers,
            key: key,
            categoryID: categoryID,
            isEnabled: true,
            isCustom: false,
            isSystem: isSystem
        )
    }
}

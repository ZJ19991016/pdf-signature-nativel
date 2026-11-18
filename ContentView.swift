import SwiftUI

struct ContentView: View {
    @State private var importedFileName: String?
    @State private var message = "从微信 PDF 的分享菜单选择「PDF签名助手」导入。"

    private let appGroupID = "group.com.example.pdfsignature"

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.text")
                    .font(.system(size: 56))
                Text("PDF签名助手")
                    .font(.title2.bold())
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                if let importedFileName {
                    Text("已接收：\(importedFileName)")
                        .font(.headline)
                    Button("选择签名 / 继续") {
                        // TODO: 在下一阶段接入 PDF 预览、绘制签名、自动插入与导出。
                    }
                    .buttonStyle(.borderedProminent)
                }
                Button("检查共享文件") {
                    loadSharedPDF()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("签名助手")
            .onAppear { loadSharedPDF() }
        }
    }

    private func loadSharedPDF() {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            message = "尚未配置 App Group。请在 Xcode 中配置共享容器。"
            return
        }

        let inbox = container.appendingPathComponent("Inbox", isDirectory: true)
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: inbox,
            includingPropertiesForKeys: nil
        ), let pdf = files.first(where: { $0.pathExtension.lowercased() == "pdf" }) else {
            message = "暂无导入的 PDF。请从微信分享 PDF 到签名助手。"
            importedFileName = nil
            return
        }

        importedFileName = pdf.lastPathComponent
        message = "PDF 已导入。下一步将接入签名与 PDF 导出。"
    }
}

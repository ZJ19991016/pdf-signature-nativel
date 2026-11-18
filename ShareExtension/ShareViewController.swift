import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    private let appGroupID = "group.com.example.pdfsignature"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "正在接收 PDF…"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        receivePDF { [weak self] result in
            DispatchQueue.main.async {
                label.text = result ? "PDF 已导入签名助手。请打开签名助手继续。" : "导入失败，请重试。"
                if result {
                    let done = UIButton(type: .system)
                    done.setTitle("完成", for: .normal)
                    done.translatesAutoresizingMaskIntoConstraints = false
                    self?.view.addSubview(done)
                    NSLayoutConstraint.activate([
                        done.centerXAnchor.constraint(equalTo: self!.view.centerXAnchor),
                        done.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24)
                    ])
                    done.addTarget(self, action: #selector(self?.finish), for: .touchUpInside)
                }
            }
        }
    }

    private func receivePDF(completion: @escaping (Bool) -> Void) {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            completion(false); return
        }
        let providers = extensionItems.flatMap { $0.attachments ?? [] }
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) }) else {
            completion(false); return
        }
        provider.loadFileRepresentation(forTypeIdentifier: UTType.pdf.identifier) { [weak self] url, error in
            guard let url, error == nil,
                  let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self?.appGroupID ?? "") else {
                completion(false); return
            }
            let inbox = container.appendingPathComponent("Inbox", isDirectory: true)
            try? FileManager.default.createDirectory(at: inbox, withIntermediateDirectories: true)
            let destination = inbox.appendingPathComponent("Imported-\(UUID().uuidString).pdf")
            do {
                // Copy while the provider's temporary file is valid.
                try FileManager.default.copyItem(at: url, to: destination)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    @objc private func finish() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

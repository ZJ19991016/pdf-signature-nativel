# PDF签名助手云端编译准备包

此包用于在 GitHub Actions 的 macOS runner 上生成 Xcode 项目并尝试编译模拟器版本。它不是安装包。

## Windows 上的下一步
1. 解压 ZIP。
2. 上传全部文件到一个新的 GitHub 仓库（推荐 Private）。
3. 仓库默认分支设为 `main`。
4. 点击 Actions 标签，若提示启用 Actions，请启用。
5. 推送文件后 workflow 会自动运行；也可 Actions → iOS Simulator Build → Run workflow。
6. 查看日志和是否生成成功。

## 限制
- 本 workflow 仅构建 iOS Simulator，未签名，不能安装到真实 iPhone。
- Share Extension target 已纳入项目生成配置，但 App Group、宿主 App 嵌入扩展、真实设备签名、PDF 签名/导出功能还需后续完善。
- Bundle IDs 和 App Group 仍是示例值。
- 源码未在本次环境执行 Xcode 编译，需由 GitHub Actions 验证。

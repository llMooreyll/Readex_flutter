# Readex

Readex 是一个使用 Flutter 构建的本地优先稍后读应用。它将网页转换为清晰易读的文章并保存在设备本地，无需账号或后端服务。

Readex is a local-first read-it-later app built with Flutter. It turns web pages into clean, readable articles stored on the device, with no account or backend service required.

## 预览 / Preview

下面是浅色和深色模式的界面总览图。

The following images show the light and dark mode interfaces.

![Readex light mode preview](https://raw.githubusercontent.com/llMooreyll/Readex_flutter/main/example/overview_light.jpg)

![Readex dark mode preview](https://raw.githubusercontent.com/llMooreyll/Readex_flutter/main/example/overview_dark.jpg)

## 功能特点 / Features

### 1. 🔗 链接导入 / Link Import

Readex 支持在应用内输入网页链接，也支持从其他 Android 应用的系统分享面板接收链接。收到的链接会自动进入抓取、解析和入库前预览流程；当页面无法解析时，应用仍然可以保存包含标题和 URL 的 link-only 条目，方便用户之后主动在浏览器中打开。

Readex accepts URLs entered in the app and links shared from other Android apps through the system share sheet. Shared links automatically enter the fetch, extraction, and pre-save preview flow. When a page cannot be parsed, Readex can still save a link-only entry containing the available title and URL for later browser access.

### 2. 📖 内容解析与阅读 / Extraction and Reading

应用使用 reader-mode 流程提取正文，并在必要时使用 HTML 解析作为回退方案，然后在 Readex 内渲染保存的文章。网站验证、反爬或 JavaScript 限制不会被绕过；如果正文或图片无法获取，应用会显示 link-only 内容或图片占位内容，保证阅读流程有明确的结果。

The app extracts article content through a reader-mode pipeline with an HTML parser fallback when needed, then renders saved content inside Readex. Website verification, anti-bot protection, and JavaScript restrictions are not bypassed. If text or images cannot be retrieved, Readex shows a link-only entry or an image placeholder so the result remains clear and usable.

### 3. 🗃️ 本地管理与编辑 / Local Management and Editing

文章使用 Drift/SQLite 保存在设备本地，不需要账号、服务器或同步服务。用户可以在 Library 和 Archived 视图之间切换，向右滑动存档、向左滑动删除，并通过浮动 Snackbar 撤销操作；还可以标记已读或未读，以及编辑标题、作者、来源和摘要等元数据，而不会改变已保存的正文内容。

Articles are stored locally with Drift/SQLite, without an account, server, or sync service. Users can switch between Library and Archived views, swipe right to archive, swipe left to delete, and undo actions from a floating Snackbar. Articles can also be marked as read or unread, and their title, author, source, and summary can be edited without changing the stored body.

### 4. 🎨 Material 3 主题与动画 / Material 3, Themes, and Motion

界面采用 Material 3 设计，包含浮动导航栏、浮动添加按钮、响应式布局和清晰紧凑的条目展示。应用支持系统、浅色和深色主题，并在支持的 Android 版本上使用 Dynamic Color；底部弹出页面、左右滑动、列表重排和撤销反馈都配有简洁连贯的动画效果。

The interface uses Material 3 with a floating navigation bar, floating add action, responsive layouts, and compact article rows. It supports system, light, and dark themes, and uses Dynamic Color on supported Android versions. Bottom sheets, swipe actions, list reordering, and undo feedback use concise, consistent motion.

## 下载 / Download

请前往 GitHub Releases 页面下载最新 Android APK，不再从代码仓库下载 APK：

Download the latest Android APK from GitHub Releases instead of the source repository:

[打开 GitHub Releases / Open GitHub Releases](https://github.com/llMooreyll/Readex_flutter/releases)

下载 APK 后可以直接安装到 Android 设备。Android 可能会要求允许当前来源安装未知应用。应用 ID 是 `com.heraklysia.read_it_later`。

After downloading the APK, install it directly on an Android device. Android may ask you to allow installations from the source used to open the APK. The application ID is `com.heraklysia.read_it_later`.

## 平台说明 / Platform Notes

文章导入、解析、本地数据库和阅读器界面使用 Dart 实现，并按照 Flutter 支持的平台设计。Android 额外实现了原生分享 Intent，用于从其他应用接收链接。

Article import, extraction, local database, and reader UI are implemented in Dart and designed around Flutter's supported platforms. Android additionally includes native share-intent handling for receiving links from other apps.

## 开发环境 / Development Environment

- Flutter 3.47.1 stable
- Dart 3.13.1
- Android SDK Platform 36
- Android SDK Build-Tools 36.0.0
- Android NDK 28.2.13676358
- Android application ID: `com.heraklysia.read_it_later`

## 开发命令 / Development Commands

以下命令需要在项目根目录执行。

Run the following commands from the project root:

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
flutter run -d emulator-5554
```

## 项目结构 / Project Structure

- `lib/app/`：应用启动、路由、主题、动画和分享链接集成 / Bootstrap, routing, themes, motion, and share-link integration
- `lib/features/articles/domain/`：文章实体和仓储接口 / Article entities and repository contracts
- `lib/features/articles/application/`：导入、保存、编辑、阅读、存档和删除用例 / Import, save, edit, read, archive, and delete use cases
- `lib/features/articles/data/`：Drift 数据库、仓储、下载器和解析流程 / Drift database, repository, downloader, and extraction pipeline
- `lib/features/articles/presentation/`：库页面、阅读页面、导入、预览和元数据编辑 / Library, reader, import, preview, and metadata editing UI
- `test/`：单元测试和 Widget 测试 / Unit and widget tests
- `example/`：浅色和深色模式总览图 / Light and dark mode overview images

机器相关文件，例如 `android/local.properties`、签名凭据、构建输出和 Gradle 缓存，均已排除在版本控制之外。

Machine-specific files such as `android/local.properties`, signing credentials, build output, and Gradle caches are excluded from version control.

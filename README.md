# Readex

Readex 是一个使用 Flutter 构建的本地优先稍后读应用。它将网页转换为清晰易读的文章并保存在设备本地，无需账号或后端服务。

Readex is a local-first read-it-later app built with Flutter. It turns web pages into clean, readable articles stored on the device, with no account or backend service required.

## 预览 / Preview

下面是浅色和深色模式的界面总览图。

The following images show the light and dark mode interfaces.

| 浅色模式 / Light mode | 深色模式 / Dark mode |
| ----------------- | ---------------- |
|                   |                  |

## 功能特点 / Features

### 🔗 多平台链接导入 / Link Import

| 中文                                   | English                                                                                         |
| ------------------------------------ | ----------------------------------------------------------------------------------------------- |
| 在应用内输入链接，或从其他 Android 应用的系统分享面板发送链接。 | Enter a URL in the app or share a link from another Android app through the system share sheet. |
| 分享的链接会自动进入解析和入库预览流程。                 | Shared links automatically enter the extraction and save-preview flow.                          |
| 支持普通网页、文章链接以及无法解析时的 link-only 条目。    | Supports regular web pages, article URLs, and link-only entries when extraction is unavailable. |

### 📖 网页解析与阅读 / Extraction and Reading

| 中文                                       | English                                                                                                                                                         |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 使用 reader-mode 流程提取正文，并使用 HTML 解析作为回退方案。 | Extracts article content through a reader-mode pipeline with an HTML parser fallback.                                                                           |
| 文章内容在 Readex 内渲染，不需要先打开浏览器。              | Renders article content inside Readex without opening the browser first.                                                                                        |
| 网站验证、反爬或解析失败时，不绕过保护机制，而是保留标题和链接供浏览器打开。   | When verification, anti-bot protection, or extraction failure occurs, Readex does not bypass the protection and preserves the title and URL for browser access. |
| 文章图片无法加载或解码失败时显示占位内容。                    | Shows a placeholder when an article image cannot be loaded or decoded.                                                                                          |

### 🗃️ 本地文章管理 / Local Library

| 中文                            | English                                                               |
| ----------------------------- | --------------------------------------------------------------------- |
| 使用 Drift/SQLite 将文章保存在设备本地。   | Stores articles locally with Drift/SQLite.                            |
| 提供 Library 和 Archived 两个列表视图。 | Provides Library and Archived list views.                             |
| 向右滑动条目进行存档，向左滑动条目进行删除。        | Swipe right to archive and swipe left to delete.                      |
| 存档和删除后提供带 Undo 的浮动 Snackbar。  | Shows a floating Snackbar with Undo after archive and delete actions. |
| 支持将条目标记为已读或未读，已读条目使用低强调文字显示。  | Mark items as read or unread, with visibly muted text for read items. |

### ✏️ 元数据编辑 / Metadata Editing

| 中文                           | English                                                                           |
| ---------------------------- | --------------------------------------------------------------------------------- |
| 可以修改已保存文章的标题、作者、来源和摘要。       | Edit the title, author, source, and summary of saved articles.                    |
| 正文内容保持不变，元数据修改独立保存。          | Article bodies remain unchanged while metadata is updated independently.          |
| 入库前可以预览抓取结果、修改元数据，然后选择保存或丢弃。 | Preview extracted data, edit metadata, and then save or discard before insertion. |

### 🎨 主题与交互 / Theme and Interaction

| 中文                                       | English                                                                                        |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 使用 Material 3 设计，包含浮动导航栏和浮动添加按钮。         | Uses Material 3 with a floating navigation bar and floating add action.                        |
| 支持系统、浅色和深色主题。                            | Supports system, light, and dark themes.                                                       |
| 支持 Android Dynamic Color；不可用时使用红色主色回退方案。 | Supports Android Dynamic Color, with a red seed-color fallback when unavailable.               |
| 底部弹出页面、左右滑动、列表重排和撤销反馈均配有简洁连贯的动画。         | Uses concise, consistent motion for sheets, swipe actions, list reordering, and undo feedback. |

## 下载 / Download

请前往 GitHub Releases 页面下载最新 Android APK：

Download the latest Android APK from GitHub Releases:

[**打开 GitHub Releases / Open GitHub Releases**](https://github.com/llMooreyll/Readex_flutter/releases)

下载 APK 后可以直接安装到 Android 设备。Android 可能会要求允许当前来源安装未知应用。应用 ID 是 `com.heraklysia.read_it_later`。

After downloading the APK, install it directly on an Android device. Android may ask you to allow installations from the source used to open the APK. The application ID is `com.heraklysia.read_it_later`.

## 平台说明 / Platform Notes

文章导入、解析、本地数据库和阅读器界面使用 Dart 实现，并按照 Flutter 支持的平台设计。Android 额外实现了原生分享 Intent，用于从其他应用接收链接。

Article import, extraction, local database, and reader UI are implemented in Dart and designed around Flutter's supported platforms. Android additionally includes native share-intent handling for receiving links from other apps.

## 开发环境 / Development Environment

| 项目 / Item               | 版本 / Version                   |
| ----------------------- | ------------------------------ |
| Flutter                 | 3.47.1 stable                  |
| Dart                    | 3.13.1                         |
| Android SDK Platform    | 36                             |
| Android SDK Build-Tools | 36.0.0                         |
| Android NDK             | 28.2.13676358                  |
| Android application ID  | `com.heraklysia.read_it_later` |

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

| 目录 / Directory                        | 内容 / Contents                                                                           |
| ------------------------------------- | --------------------------------------------------------------------------------------- |
| `lib/app/`                            | 应用启动、路由、主题、动画和分享链接集成 / Bootstrap, routing, themes, motion, and share-link integration   |
| `lib/features/articles/domain/`       | 文章实体和仓储接口 / Article entities and repository contracts                                   |
| `lib/features/articles/application/`  | 导入、保存、编辑、阅读、存档和删除用例 / Import, save, edit, read, archive, and delete use cases           |
| `lib/features/articles/data/`         | Drift 数据库、仓储、下载器和解析流程 / Drift database, repository, downloader, and extraction pipeline |
| `lib/features/articles/presentation/` | 库页面、阅读页面、导入、预览和元数据编辑 / Library, reader, import, preview, and metadata editing UI        |
| `test/`                               | 单元测试和 Widget 测试 / Unit and widget tests                                                 |
| `example/`                            | 浅色和深色模式总览图 / Light and dark mode overview images                                        |

机器相关文件，例如 `android/local.properties`、签名凭据、构建输出和 Gradle 缓存，均已排除在版本控制之外。

Machine-specific files such as `android/local.properties`, signing credentials, build output, and Gradle caches are excluded from version control.

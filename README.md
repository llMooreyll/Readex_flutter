# 稍后读

一个纯本地优先的 Flutter Android 稍后读应用。

当前阶段是项目基线：应用只包含最小 Material 3 外壳，业务功能会按
`DEVELOPMENT_PLAN.md` 中的步骤逐步实现。

当前 Android applicationId 为 `com.heraklysia.read_it_later`。

## 开发环境

- Flutter 3.47.1 stable
- Dart 3.13.1
- Android SDK Platform 36
- Android SDK Build-Tools 36.0.0
- Android NDK 28.2.13676358
- Android Studio bundled JDK

Android APK 已在本机模拟器上完成过构建、安装和启动验证。当前 Android
Command-line Tools 23 将旧的 `sdkmanager --licenses` 入口标记为弃用，因此
Flutter Doctor 可能仍显示 license status unknown；实际构建时 SDK license
已被 Android 工具接受。

## 常用命令

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
flutter run -d emulator-5554
```

`android/local.properties` 由 Flutter/Android Studio 生成，包含本机路径，
不应提交到 Git。

## 目录约定

- `lib/`：应用源代码
- `test/`：自动化测试
- `work/`：本地调研和实验资料，不参与应用分析和构建
- `DEVELOPMENT_PLAN.md`：产品范围、架构和实施计划

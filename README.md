# Max Flutter App

一个基于Flutter框架的多平台应用程序，支持Android、iOS和Web平台。

## 📱 项目概述

Max Flutter App是一个跨平台移动应用项目，旨在通过单一代码库实现"一次编写，多平台运行"的目标。

### 🚀 主要功能

- ✅ **跨平台支持**: Android、iOS、Web
- ✅ **用户认证系统**: 登录、注册、用户管理
- ✅ **社区论坛**: 帖子发布、评论、点赞
- ✅ **消息系统**: 私聊、通知
- ✅ **个人中心**: 用户资料、设置

### 🛠️ 技术栈

- **框架**: Flutter 3.35.3
- **语言**: Dart
- **状态管理**: Provider
- **网络请求**: Dio
- **本地存储**: SharedPreferences
- **图片缓存**: CachedNetworkImage

## 📦 项目结构

```
lib/
├── constants/          # 常量配置
│   ├── api_constants.dart
│   ├── app_constants.dart
│   └── app_theme.dart
├── models/            # 数据模型
│   ├── api_response.dart
│   ├── post_model.dart
│   └── user_model.dart
├── pages/             # 页面组件
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── community_page.dart
│   └── ...
├── providers/         # 状态管理
│   └── user_provider.dart
├── services/          # 服务层
│   └── api_service.dart
├── utils/             # 工具类
│   └── storage_utils.dart
├── widgets/           # UI组件
│   ├── post_card.dart
│   ├── search_bar_widget.dart
│   └── ...
└── main.dart          # 应用入口
```

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Git

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/your-username/max-flutter-app.git
   cd max-flutter-app
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **生成代码**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **运行项目**
   ```bash
   # Web平台
   flutter run -d chrome
   
   # Android平台
   flutter run -d android
   
   # iOS平台 (需要macOS)
   flutter run -d ios
   ```

## 📱 支持平台

| 平台 | 状态 | 说明 |
|------|------|------|
| 🌐 Web | ✅ 支持 | Chrome、Safari、Firefox等现代浏览器 |
| 🤖 Android | ✅ 支持 | Android 5.0+ (API 21+) |
| 🍎 iOS | ✅ 支持 | iOS 12.0+ (需要macOS开发环境) |

## 🛠️ 开发指南

### 代码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 编码规范
- 使用 `flutter analyze` 进行静态代码分析
- 所有公共方法需要添加文档注释

### 构建命令

```bash
# 构建Web版本
flutter build web

# 构建Android APK
flutter build apk

# 构建Android App Bundle
flutter build appbundle

# 构建iOS (需要macOS)
flutter build ios
```

## 📖 API文档

详细的API接口文档请参考: [接口文档.md](./接口文档.md)

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📧 联系方式

- 项目维护者: Max Developer
- 邮箱: max.developer@example.com
- 项目地址: [https://github.com/your-username/max-flutter-app](https://github.com/your-username/max-flutter-app)

## 🎯 待办事项

- [ ] 添加单元测试
- [ ] 实现推送通知
- [ ] 添加多语言支持
- [ ] 优化性能
- [ ] 添加离线支持

---

⭐ 如果这个项目对您有帮助，请给它一个星标！
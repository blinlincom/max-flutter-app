# Max Flutter App

![Flutter Version](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.9.2-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)

<div align="center">
  <h3>🎯 基于Flutter的跨平台源码分享社区应用</h3>
  <p>一次编写，三端运行 | 现代化架构 | Material Design</p>
</div>

---

## 🌟 项目亮点

<table>
  <tr>
    <td>✨ <strong>跨平台支持</strong></td>
    <td>Android + iOS + Web 一套代码，三端运行</td>
  </tr>
  <tr>
    <td>🏗️ <strong>现代架构</strong></td>
    <td>MVVM + Repository 模式，代码结构清晰</td>
  </tr>
  <tr>
    <td>🎨 <strong>Material Design</strong></td>
    <td>遵循Google设计规范，用户体验优秀</td>
  </tr>
  <tr>
    <td>🔐 <strong>完整认证</strong></td>
    <td>用户登录、注册、状态管理一应俱全</td>
  </tr>
  <tr>
    <td>🌐 <strong>网络层</strong></td>
    <td>Dio + 拦截器，请求响应处理完善</td>
  </tr>
  <tr>
    <td>📱 <strong>响应式UI</strong></td>
    <td>适配各种屏幕尺寸，完美的移动端体验</td>
  </tr>
</table>

## 📋 功能模块

### 🚀 核心功能

- ✅ **用户认证系统**: 登录、注册、用户管理
- ✅ **社区论坛**: 帖子发布、评论、点赞
- ✅ **消息系统**: 私聊、通知
- ✅ **个人中心**: 用户资料、设置
- ✅ **搜索功能**: 内容搜索、用户搜索

### 🎨 UI特色

- 🌈 **主色调**: #FF6900 温暖橙色，现代简约
- 📱 **响应式设计**: 自适应手机、平板、桌面
- ✨ **流畅动画**: 页面切换、按钮点击效果
- 🌑 **主题适配**: 支持深色/浅色模式

## 🛠️ 技术架构

### 📚 技术栈

| 类别 | 技术 | 版本 | 说明 |
|------|----|------|------|
| 📱 核心框架 | Flutter | 3.35.3 | 跨平台UI框架 |
| 📝 编程语言 | Dart | 3.9.2 | 高效的客户端开发语言 |
| 📊 状态管理 | Provider | ^6.0.5 | 简单易用的状态管理 |
| 🌐 网络请求 | Dio | ^5.3.2 | 强大的HTTP客户端 |
| 💾 本地存储 | SharedPreferences | ^2.2.2 | 轻量级本地数据存储 |
| 🖼️ 图片缓存 | CachedNetworkImage | ^3.3.0 | 高效的网络图片缓存 |
| 🔄 代码生成 | json_serializable | ^6.7.1 | JSON序列化代码生成 |

### 🏗️ 架构模式

```
graph TB
    subgraph "Presentation Layer"
        A[Pages] --> B[Widgets]
        B --> C[Theme]
    end
    
    subgraph "Business Logic Layer"
        D[Providers] --> E[Models]
        E --> F[Constants]
    end
    
    subgraph "Data Layer"
        G[Services] --> H[API Client]
        G --> I[Local Storage]
    end
    
    subgraph "Core Layer"
        J[Utils] --> K[Extensions]
    end
    
    A --> D
    D --> G
    G --> J
```

## 📦 项目结构

```
lib/
├── constants/          # 常量配置
│   ├── api_constants.dart     # API接口常量
│   ├── app_constants.dart     # 应用常量
│   └── app_theme.dart         # 主题配置
├── models/            # 数据模型
│   ├── api_response.dart      # API响应模型
│   ├── post_model.dart        # 帖子模型
│   ├── user_model.dart        # 用户模型
│   └── app_category_model.dart # 分类模型
├── pages/             # 页面组件
│   ├── splash_page.dart       # 启动页
│   ├── main_page.dart         # 主页面
│   ├── home_page.dart         # 首页
│   ├── login_page.dart        # 登录页
│   ├── community_page.dart    # 社区页
│   ├── message_page.dart      # 消息页
│   └── profile_page.dart      # 个人主页
├── providers/         # 状态管理
│   └── user_provider.dart     # 用户状态管理
├── services/          # 服务层
│   └── api_service.dart       # API服务
├── utils/             # 工具类
│   ├── storage_utils.dart     # 存储工具
│   └── category_icon_manager.dart # 图标管理
├── widgets/           # UI组件
│   ├── post_card.dart         # 帖子卡片
│   ├── source_code_card.dart  # 源码卡片
│   ├── search_bar_widget.dart # 搜索栏
│   ├── section_header.dart    # 章节标题
│   └── category_icon.dart     # 分类图标
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
   git clone https://github.com/blinlincom/max-flutter-app.git
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
   # Web平台 (推荐首次体验)
   flutter run -d chrome
   
   # Android平台
   flutter run -d android
   
   # iOS平台 (需要macOS)
   flutter run -d ios
   ```

## 📱 支持平台

| 平台 | 状态 | 最低版本 | 说明 |
|------|------|----------|------|
| 🌐 Web | ✅ 完全支持 | Chrome 88+ | 现代浏览器，推荐Chrome |
| 🤖 Android | ✅ 完全支持 | API 21+ (Android 5.0) | 支持ARM/ARM64 |
| 🍎 iOS | ✅ 完全支持 | iOS 12.0+ | 需要macOS开发环境 |

## 🛠️ 开发指南

### 代码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 编码规范
- 使用 `flutter analyze` 进行静态代码分析
- 所有公共方法需要添加文档注释
- 使用 `dart format` 格式化代码

### 构建命令

```
# 开发环境运行
flutter run --debug

# 构建Web版本
flutter build web --release

# 构建Android APK
flutter build apk --release

# 构建Android App Bundle (推荐)
flutter build appbundle --release

# 构建iOS (需要macOS)
flutter build ios --release
```

### 测试命令

```
# 运行所有测试
flutter test

# 运行测试并生成覆盖率报告
flutter test --coverage

# 分析代码质量
flutter analyze
```

## 📖 API文档

项目使用RESTful API设计，详细的接口文档请参考:
- 📋 [API接口文档](./接口文档.md) - 完整的API接口说明
- 🔐 [认证机制说明](./docs/AUTH.md) - 用户认证流程
- 📝 [数据模型定义](./docs/MODELS.md) - 数据结构说明

## 🎯 核心特性演示

### 🔐 用户认证流程
- 支持邮箱/手机号登录
- JWT Token自动管理
- 登录状态持久化
- 自动登录/退出机制

### 📱 社区功能
- 帖子发布与浏览
- 实时评论系统
- 点赞收藏功能
- 用户关注机制

### 🎨 UI/UX设计
- Material 3.0设计语言
- 响应式布局设计
- 流畅的页面转场动画
- 深色模式支持

## 🤝 贡献指南

我们欢迎所有形式的贡献！请阅读以下指南：

1. **Fork** 本仓库到您的GitHub账户
2. **创建特性分支** (`git checkout -b feature/AmazingFeature`)
3. **提交更改** (`git commit -m 'Add some AmazingFeature'`)
4. **推送到分支** (`git push origin feature/AmazingFeature`)
5. **创建Pull Request**

### 贡献类型
- 🐛 Bug修复
- ✨ 新功能开发
- 📝 文档完善
- 🎨 UI/UX改进
- ⚡ 性能优化

## 📄 许可证

本项目采用 **MIT许可证** - 查看 [LICENSE](LICENSE) 文件了解详情

MIT许可证允许您：
- ✅ 商业使用
- ✅ 修改源码
- ✅ 分发
- ✅ 私人使用

## 📧 联系方式

- 👨‍💻 **项目维护者**: Max Developer
- 📮 **邮箱**: max.developer@example.com
- 🌐 **项目主页**: [https://github.com/blinlincom/max-flutter-app](https://github.com/blinlincom/max-flutter-app)
- 💬 **问题反馈**: [GitHub Issues](https://github.com/blinlincom/max-flutter-app/issues)

## 🚧 开发路线图

### 🎯 短期目标 (v1.1.0)
- [ ] 添加单元测试覆盖率 80%+
- [ ] 实现推送通知功能
- [ ] 优化启动速度和内存使用
- [ ] 支持多语言国际化

### 🌟 中期目标 (v2.0.0)
- [ ] 引入AI内容推荐
- [ ] 实现实时聊天功能
- [ ] 添加深色主题完整支持
- [ ] 桌面端原生应用

### 🚀 长期目标 (v3.0.0)
- [ ] 微服务架构重构
- [ ] 区块链技术集成
- [ ] AR/VR内容展示
- [ ] 全平台统一体验

## 📊 项目统计

![GitHub stars](https://img.shields.io/github/stars/blinlincom/max-flutter-app?style=social)
![GitHub forks](https://img.shields.io/github/forks/blinlincom/max-flutter-app?style=social)
![GitHub issues](https://img.shields.io/github/issues/blinlincom/max-flutter-app)
![GitHub pull requests](https://img.shields.io/github/issues-pr/blinlincom/max-flutter-app)

---

<div align="center">
  <h3>⭐ 如果这个项目对您有帮助，请给它一个星标！</h3>
  <p>您的支持是我们持续改进的动力 🚀</p>
</div>

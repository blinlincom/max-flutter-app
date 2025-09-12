/// 应用常量
class AppConstants {
  /// 应用名称
  static const String appName = '源码分享社区';

  /// 版本信息
  static const String version = '1.0.0';

  /// 分页大小
  static const int pageSize = 20;

  /// 本地存储Key
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String userInfoKey = 'user_info';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String themeKey = 'theme_mode';

  /// 默认头像
  static const String defaultAvatar =
      'https://via.placeholder.com/100x100/e0e0e0/9e9e9e?text=头像';

  /// 默认背景
  static const String defaultBackground =
      'https://via.placeholder.com/400x200/f5f5f5/9e9e9e?text=背景';

  /// 图片占位符
  static const String imagePlaceholder =
      'https://via.placeholder.com/200x150/f5f5f5/9e9e9e?text=图片';

  /// 轮播图默认高度
  static const double bannerHeight = 200.0;

  /// 帖子预览内容长度
  static const int postPreviewLength = 100;

  /// 支持的图片格式
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  /// 支持的视频格式
  static const List<String> supportedVideoFormats = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
  ];

  /// 最大文件上传大小 (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  /// 网络请求超时时间
  static const int networkTimeout = 30000; // 30秒
}

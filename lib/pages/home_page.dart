import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart'; // 添加AppConstants导入
import '../widgets/search_bar_widget.dart';
import '../widgets/category_icon.dart';
import '../utils/category_icon_manager.dart';
import '../utils/storage_utils.dart'; // 添加StorageUtils导入
import '../services/api_service.dart';
import '../models/app_category_model.dart';
import '../models/stats_model.dart';
import '../models/post_model.dart'; // 添加PostModel导入

/// 首页 - 小米风格现代化设计
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentBannerIndex = 0;
  List<AppSubCategoryModel> _categories = [];
  bool _isLoadingCategories = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _bannerPageController;
  Timer? _bannerTimer;

  // 添加统计数据相关变量
  StatsModel? _statsData;
  bool _isLoadingStats = false;

  // 添加热门帖子相关变量
  List<PostModel> _popularPosts = [];
  bool _isLoadingPopularPosts = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 初始化轮播图控制器
    _bannerPageController = PageController(viewportFraction: 0.88);

    // 启动动画
    _animationController.forward();

    // 启动轮播图定时器
    _startBannerTimer();

    // 加载数据
    _loadCategories();
    _loadStatsData(); // 加载统计数据
    _loadPopularPosts(); // 加载热门帖子
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  /// 启动轮播图自动播放
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % _banners.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// 停止轮播图自动播放
  void _stopBannerTimer() {
    _bannerTimer?.cancel();
  }

  /// 加载应用分类数据
  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await ApiService().getAppCategoryList(limit: 20);
      if (response.isSuccess && response.data != null) {
        List<AppSubCategoryModel> allChildren = [];
        for (final parentCategory in response.data!.list) {
          if (parentCategory.children != null &&
              parentCategory.children!.isNotEmpty) {
            allChildren.addAll(parentCategory.children!);
          }
        }

        setState(() {
          _categories = allChildren;
        });

        debugPrint('成功加载 ${allChildren.length} 个子分类');
      } else {
        debugPrint('获取分类列表失败: ${response.message}');
      }
    } catch (e) {
      debugPrint('获取分类列表错误: $e');
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  /// 加载统计数据
  Future<void> _loadStatsData() async {
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final response = await ApiService().getAppStatisticalData();
      if (response.isSuccess && response.data != null) {
        setState(() {
          _statsData = response.data;
        });

        debugPrint('成功加载统计数据');
      } else {
        debugPrint('获取统计数据失败: ${response.message}');
      }
    } catch (e) {
      debugPrint('获取统计数据错误: $e');
    } finally {
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  /// 加载热门帖子数据
  Future<void> _loadPopularPosts() async {
    setState(() {
      _isLoadingPopularPosts = true;
    });

    try {
      // 检查用户是否登录（通过检查是否有用户token）
      final userToken = await StorageUtils.getString(AppConstants.userTokenKey);
      final includeUserToken = userToken != null && userToken.isNotEmpty;

      final response = await ApiService().getPopularPosts(
        limit: 10,
        includeUserToken: includeUserToken, // 根据用户登录状态决定是否传递usertoken
      );
      if (response.isSuccess && response.data != null) {
        setState(() {
          _popularPosts = response.data!.list;
        });

        debugPrint('成功加载 ${_popularPosts.length} 个热门帖子');
      } else {
        debugPrint('获取热门帖子失败: ${response.message}');
      }
    } catch (e) {
      debugPrint('获取热门帖子错误: $e');
    } finally {
      setState(() {
        _isLoadingPopularPosts = false;
      });
    }
  }

  // 轮播图数据 - 小米风格
  final List<BannerItem> _banners = [
    BannerItem(
      image: 'https://picsum.photos/800/400?random=1',
      title: '精选项目',
      subtitle: '开源社区热门推荐，优质代码分享',
      color: const Color(0xFF4285F4),
    ),
    BannerItem(
      image: 'https://picsum.photos/800/400?random=2',
      title: '跨平台开发',
      subtitle: '一次编写，多端运行，提升开发效率',
      color: const Color(0xFF34A853),
    ),
    BannerItem(
      image: 'https://picsum.photos/800/400?random=3',
      title: '现代Web应用',
      subtitle: '响应式设计，完美适配各种设备',
      color: const Color(0xFF9C27B0),
    ),
  ];

  // 热门源码 - 精选内容（已替换为从API获取的热门帖子数据）

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true, // 保持为 true
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadCategories,
            color: AppTheme.primaryColor,
            child: CustomScrollView(
              slivers: [
                // 现代化 AppBar - 保持原样
                SliverAppBar(
                  expandedHeight: 180,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildModernHeaderBackground(),
                  ),
                  // 保持 AppBar 内容不变
                ),

                // 主要内容区域
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // 快捷功能区
                        _buildQuickActionsSection(),

                        const SizedBox(height: 20),

                        // 轮播图
                        _buildBannerSection(),

                        const SizedBox(height: 24),

                        // 分类导航
                        _buildCategorySection(),

                        const SizedBox(height: 24),

                        // 热门推荐
                        _buildPopularSection(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 删除浮动搜索按钮
          // _buildFloatingSearchButton(),
        ],
      ),
    );
  }

  /// 构建现代化头部背景 - 毛玻璃效果
  Widget _buildModernHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.05),
            AppTheme.primaryColor.withOpacity(0.02),
            Colors.white.withOpacity(0.8),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 防止溢出
              children: [
                // 顶部状态栏区域
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 左侧时间显示
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '发现优质开源项目 ✨',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    // 右侧操作按钮 - 在扫码功能前面添加搜索按钮
                    Row(
                      children: [
                        _buildGlassmorphismButton(
                          icon: Icons.search_rounded,
                          onTap: _showSearchDialog, // 添加搜索功能
                        ),
                        const SizedBox(width: 12),
                        _buildGlassmorphismButton(
                          icon: Icons.qr_code_scanner_rounded,
                          onTap: () {
                            // TODO: 扫码功能
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildGlassmorphismButton(
                          icon: Icons.notifications_none_rounded,
                          showBadge: true,
                          onTap: () {
                            // TODO: 通知页面
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16), // 缩小间距
                // 数据统计卡片 - 毛玻璃效果
                _buildStatsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建毛玻璃效果按钮
  Widget _buildGlassmorphismButton({
    required IconData icon,
    bool showBadge = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon, size: 22, color: AppTheme.textPrimaryColor),
            ),
            if (showBadge)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: AppTheme.errorColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建数据统计卡片
  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.visibility_rounded,
              count: _isLoadingStats
                  ? '...'
                  : _statsData != null
                  ? '${_formatNumber(_statsData!.viewCount)}+'
                  : '128K+',
              label: '访问量',
              color: AppTheme.primaryColor,
            ),
          ),
          Container(width: 1, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.people_rounded,
              count: _isLoadingStats
                  ? '...'
                  : _statsData != null
                  ? '${_formatNumber(_statsData!.userCount)}+'
                  : '58K+',
              label: '用户',
              color: AppTheme.accentColor,
            ),
          ),
          Container(width: 1, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.person_add_rounded,
              count: _isLoadingStats
                  ? '...'
                  : _statsData != null
                  ? _formatNumber(_statsData!.todayUserCount)
                  : '256',
              label: '今日注册',
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppTheme.textSecondaryColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建快捷功能区域
  Widget _buildQuickActionsSection() {
    final quickActions = [
      QuickActionItem(
        icon: Icons.trending_up_rounded,
        label: '热门趋势',
        color: const Color(0xFF4285F4),
        onTap: () => debugPrint('热门趋势'),
      ),
      QuickActionItem(
        icon: Icons.new_releases_rounded,
        label: '最新发布',
        color: const Color(0xFF34A853),
        onTap: () => debugPrint('最新发布'),
      ),
      QuickActionItem(
        icon: Icons.bookmark_rounded,
        label: '我的收藏',
        color: const Color(0xFFFF6900),
        onTap: () => debugPrint('我的收藏'),
      ),
      QuickActionItem(
        icon: Icons.history_rounded,
        label: '最近查看',
        color: const Color(0xFF9C27B0),
        onTap: () => debugPrint('最近查看'),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: quickActions.map((action) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildQuickActionItem(action),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建快捷操作项
  Widget _buildQuickActionItem(QuickActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(action.icon, size: 18, color: action.color),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 获取问候语
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '早上好';
    } else if (hour < 18) {
      return '下午好';
    } else {
      return '晚上好';
    }
  }

  /// 显示搜索对话框 - 无斑马线效果的优化版本
  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white, // 确保背景为纯白色
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 顶部指示条
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 搜索栏区域
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white, // 确保背景为白色
                border: Border(
                  bottom: BorderSide(color: AppTheme.separatorColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      autofocus: true,
                      onSearch: (keyword) {
                        Navigator.pop(context);
                        debugPrint('搜索关键词: $keyword');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('取消'),
                  ),
                ],
              ),
            ),
            // 搜索建议
            Expanded(
              child: Container(
                color: Colors.white, // 确保背景为纯白色
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(), // 使用更平滑的滚动物理效果
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        '热门搜索',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Flutter',
                          'React',
                          'Vue',
                          'SpringBoot',
                          '微信小程序',
                          'Android',
                          'iOS',
                          'Python',
                        ].map((tag) => _buildSearchTag(tag)).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 添加搜索历史部分
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        '搜索历史',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 搜索历史列表 - 消除可能的斑马线效果
                    ...['Flutter开源项目', 'React组件库', 'Vue3管理系统'].map(
                      (history) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // 确保每个项目背景为白色
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.history_rounded,
                            size: 18,
                            color: AppTheme.textHintColor,
                          ),
                          title: Text(
                            history,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              // 删除历史记录
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppTheme.textHintColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            debugPrint('点击搜索历史: $history');
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建搜索标签 - 无斑马线效果
  Widget _buildSearchTag(String tag) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        debugPrint('点击搜索标签: $tag');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, // 确保背景为白色
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 构建轮播图区域 - 现代化设计与Neumorphism风格
  Widget _buildBannerSection() {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: GestureDetector(
            onTapDown: (_) => _stopBannerTimer(),
            onTapUp: (_) => _startBannerTimer(),
            onTapCancel: () => _startBannerTimer(),
            child: PageView.builder(
              controller: _bannerPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                final isCenter = index == _currentBannerIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: isCenter ? 0 : 12,
                  ),
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(isCenter ? 0 : 0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: banner.color.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 背景图片与新渐变覆盖
                          CachedNetworkImage(
                            imageUrl: banner.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    banner.color.withOpacity(0.3),
                                    banner.color.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    banner.color.withOpacity(0.4),
                                    banner.color.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '精美封面',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 优雅的渐变遮罩与毛玻璃效果
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.3, 0.7, 1.0],
                              ),
                            ),
                          ),

                          // 内容区域优化
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 现代化标签
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '热门推荐',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // 标题优化
                                Text(
                                  banner.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 2,
                                ),

                                const SizedBox(height: 8),

                                // 描述优化
                                Text(
                                  banner.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                ),

                                const SizedBox(height: 16),

                                // 行动按钮
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '查看详情',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 现代化点击效果
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                debugPrint('点击轮播图: ${banner.title}');
                              },
                              borderRadius: BorderRadius.circular(24),
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 新潮指示器设计
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBannerIndex == index ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: _currentBannerIndex == index
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建分类导航区域 - 精美的单行水平布局
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // 标题区域优化
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '应用分类',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '发现更多精彩内容',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 加载指示器或更多按钮
              if (_isLoadingCategories)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '查看全部',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 精美的单行水平布局
        if (_categories.isEmpty && !_isLoadingCategories)
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.textHintColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.category_outlined,
                    size: 28,
                    color: AppTheme.textHintColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '暂无分类数据',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '稍后再试试吧',
                  style: TextStyle(color: AppTheme.textHintColor, fontSize: 12),
                ),
              ],
            ),
          )
        else
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildHorizontalCategoryItem(category, index);
              },
            ),
          ),
      ],
    );
  }

  /// 构建水平排列的分类项 - 精美设计
  Widget _buildHorizontalCategoryItem(AppSubCategoryModel category, int index) {
    final categoryColor = CategoryIconManager.getColorById(category.id);

    return Container(
      width: 80,
      margin: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圆形图标容器
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: categoryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: CategoryIcon(
                networkIconUrl: category.icon,
                categoryName: category.name,
                categoryId: category.id,
                size: 26,
                color: categoryColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 分类名称
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 构建热门推荐区域 - 现代简约设计
  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // 标题区域 - 简约设计
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '热门推荐',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(
                        '发现社区热门内容',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 更多按钮 - 简约设计
              TextButton(
                onPressed: () {
                  // TODO: 跳转到更多热门内容页面
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '更多',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 热门内容列表
        if (_isLoadingPopularPosts)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_popularPosts.isEmpty)
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.dividerColor.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 32,
                  color: AppTheme.textHintColor,
                ),
                const SizedBox(height: 8),
                const Text(
                  '暂无热门内容',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '稍后再试试吧',
                  style: TextStyle(color: AppTheme.textHintColor, fontSize: 12),
                ),
              ],
            ),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularPosts.length,
              itemBuilder: (context, index) {
                final post = _popularPosts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildPopularPostItem(post),
                );
              },
            ),
          ),
      ],
    );
  }

  /// 构建热门帖子项 - 简约列表样式
  Widget _buildPopularPostItem(PostModel post) {
    return GestureDetector(
      onTap: () {
        debugPrint('点击帖子: ${post.title}');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.dividerColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧图片区域（如果有的话）
            if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrls!.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // 右侧内容区域 - 根据是否有图片调整布局
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // 描述
                  Text(
                    post.content,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      height: 1.4,
                    ),
                    maxLines:
                        post.imageUrls != null && post.imageUrls!.isNotEmpty
                        ? 2
                        : 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // 底部信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 作者和时间
                      Expanded(
                        child: Row(
                          children: [
                            // 作者头像
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    post.avatar != null &&
                                        post.avatar.isNotEmpty
                                    ? Image.network(
                                        post.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.person_rounded,
                                                  size: 12,
                                                  color: AppTheme.primaryColor,
                                                ),
                                      )
                                    : Icon(
                                        Icons.person_rounded,
                                        size: 12,
                                        color: AppTheme.primaryColor,
                                      ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            // 作者昵称
                            Text(
                              post.nickname,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHintColor,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // 时间
                            Text(
                              post.createTimeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHintColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 状态标签
                      if (post.sticky == 1 ||
                          post.popular == 1 ||
                          post.featured == 1)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: post.sticky == 1
                                ? AppTheme.primaryColor.withOpacity(0.1)
                                : post.popular == 1
                                ? AppTheme.warningColor.withOpacity(0.1)
                                : AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            post.sticky == 1
                                ? '置顶'
                                : post.popular == 1
                                ? '热门'
                                : '精华',
                            style: TextStyle(
                              fontSize: 10,
                              color: post.sticky == 1
                                  ? AppTheme.primaryColor
                                  : post.popular == 1
                                  ? AppTheme.warningColor
                                  : AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取标签颜色
  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'flutter':
        return const Color(0xFF02569B);
      case 'react':
        return const Color(0xFF61DAFB);
      case 'vue':
      case 'vue3':
        return const Color(0xFF4FC08D);
      case 'typescript':
        return const Color(0xFF3178C6);
      case 'next.js':
        return const Color(0xFF000000);
      case 'element plus':
        return const Color(0xFF409EFF);
      case 'material3':
        return const Color(0xFF6750A4);
      default:
        return AppTheme.primaryColor;
    }
  }

  /// 格式化数字显示
  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}W';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}

/// 轮播图数据模型 - 增强版
class BannerItem {
  final String image;
  final String title;
  final String subtitle;
  final Color color;

  BannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

/// 源码数据模型
class SourceCodeItem {
  final String title;
  final String description;
  final String author;
  final int downloads;
  final double rating;
  final List<String> tags;
  final String image;

  SourceCodeItem({
    required this.title,
    required this.description,
    required this.author,
    required this.downloads,
    required this.rating,
    required this.tags,
    required this.image,
  });
}

/// 快捷操作数据模型
class QuickActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

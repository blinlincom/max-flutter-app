import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../constants/app_theme.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_icon.dart';
import '../utils/category_icon_manager.dart';
import '../services/api_service.dart';
import '../models/app_category_model.dart';

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

    _loadCategories();
    _animationController.forward();

    // 启动自动轮播
    _startBannerTimer();
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

  // 轮播图数据 - 小米风格
  final List<BannerItem> _banners = [
    BannerItem(
      image: 'https://picsum.photos/800/400?random=1',
      title: '精选Flutter项目',
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

  // 热门源码 - 精选内容
  final List<SourceCodeItem> _popularCodes = [
    SourceCodeItem(
      title: 'Flutter聊天应用',
      description: '基于Flutter开发的现代化即时通讯应用，支持多媒体消息、群聊、语音通话等功能',
      author: '开发者小米',
      downloads: 1250,
      rating: 4.8,
      tags: ['Flutter', 'Chat', 'Real-time', 'Material3'],
      image: 'https://picsum.photos/300/200?random=10',
    ),
    SourceCodeItem(
      title: 'React电商平台',
      description: '完整的现代化电商解决方案，包含商品展示、购物车、支付、订单管理等完整功能',
      author: '前端大师',
      downloads: 890,
      rating: 4.6,
      tags: ['React', 'E-commerce', 'TypeScript', 'Next.js'],
      image: 'https://picsum.photos/300/200?random=11',
    ),
    SourceCodeItem(
      title: 'Vue管理系统',
      description: 'Vue3 + TypeScript构建的企业级后台管理系统，支持权限管理、数据可视化、多主题',
      author: '全栈工程师',
      downloads: 650,
      rating: 4.7,
      tags: ['Vue3', 'TypeScript', 'Admin', 'Element Plus'],
      image: 'https://picsum.photos/300/200?random=12',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _loadCategories,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            // 现代化无标题AppBar
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _buildIntegratedSearchBar(),
                ),
              ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

                  // 右侧操作按钮
                  Row(
                    children: [
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

              const SizedBox(height: 20),

              // 数据统计卡片 - 毛玻璃效果
              _buildStatsCard(),
            ],
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
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
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
              icon: Icons.code_rounded,
              count: '1.2K+',
              label: '开源项目',
              color: AppTheme.primaryColor,
            ),
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.people_rounded,
              count: '58K+',
              label: '开发者',
              color: AppTheme.accentColor,
            ),
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star_rounded,
              count: '4.8',
              label: '平均评分',
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
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppTheme.textSecondaryColor),
        ),
      ],
    );
  }

  /// 构建集成搜索栏
  Widget _buildIntegratedSearchBar() {
    return GestureDetector(
      onTap: () {
        _showSearchDialog();
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 20, color: AppTheme.textHintColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '搜索开源项目、技术文档...',
                style: TextStyle(fontSize: 14, color: AppTheme.textHintColor),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'AI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
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

  /// 显示搜索对话框
  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 搜索栏
            Container(
              padding: const EdgeInsets.all(20),
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
                    child: const Text('取消'),
                  ),
                ],
              ),
            ),
            // 搜索建议
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    '热门搜索',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建搜索标签
  Widget _buildSearchTag(String tag) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        debugPrint('点击搜索标签: $tag');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.containerColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.dividerColor, width: 0.5),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  /// 构建轮播图区域 - 现代化设计与Neumorphism风格
  Widget _buildBannerSection() {
    return Column(
      children: [
        Container(
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
                                  overflow: TextOverflow.ellipsis,
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
                                  overflow: TextOverflow.ellipsis,
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

  /// 构建分类导航区域 - 现代化网格卡片设计
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
                Container(
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

        // 分类网格区域
        if (_categories.isEmpty && !_isLoadingCategories)
          Container(
            height: 140,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _categories.length > 8 ? 8 : _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildModernCategoryItem(category, index);
              },
            ),
          ),
      ],
    );
  }

  /// 构建现代化分类项
  Widget _buildModernCategoryItem(AppSubCategoryModel category, int index) {
    final categoryColor = CategoryIconManager.getColorById(category.id);

    return GestureDetector(
      onTap: () {
        debugPrint('点击分类: ${category.name} (ID: ${category.id})');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (index * 50)),
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
            border: Border.all(
              color: categoryColor.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 图标容器优化
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.1),
                      categoryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: CategoryIcon(
                  networkIconUrl: category.icon,
                  categoryName: category.name,
                  categoryId: category.id,
                  size: 24,
                  color: categoryColor,
                ),
              ),

              const SizedBox(height: 10),

              // 分类名称优化
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 2),

              // 小点装饰
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建热门推荐区域 - 现代化卡片设计
  Widget _buildPopularSection() {
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
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.primaryColor.withOpacity(0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '热门推荐',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '精选优质内容，每日更新',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 更多按钮
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                  ),
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
                      '查看更多',
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

        // 卡片列表
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _popularCodes.length,
          itemBuilder: (context, index) {
            final code = _popularCodes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: _buildModernSourceCodeCard(code, index),
            );
          },
        ),
      ],
    );
  }

  /// 构建现代化源码卡片
  Widget _buildModernSourceCodeCard(SourceCodeItem code, int index) {
    return GestureDetector(
      onTap: () {
        debugPrint('点击源码: ${code.title}');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: -8,
            ),
          ],
          border: Border.all(
            color: AppTheme.dividerColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部图片区域
            Container(
              height: 160,
              child: Stack(
                children: [
                  // 背景图片
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: code.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor.withOpacity(0.1),
                                AppTheme.primaryColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.code_rounded,
                              size: 32,
                              color: AppTheme.primaryColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor.withOpacity(0.15),
                                AppTheme.primaryColor.withOpacity(0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.code_rounded,
                              size: 32,
                              color: AppTheme.primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 渐变遮罩
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // 评分和下载量
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppTheme.warningColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            code.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 下载量
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${code.downloads}',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 内容区域
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    code.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // 描述
                  Text(
                    code.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // 作者信息
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              code.author,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '开发者',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 技术标签
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: code.tags.take(4).map((tag) {
                      final tagColor = _getTagColor(tag);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tagColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: tagColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: tagColor,
                          ),
                        ),
                      );
                    }).toList(),
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

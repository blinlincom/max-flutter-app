import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constants/app_theme.dart';
import '../models/post_model.dart';

import '../providers/user_provider.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';
import '../widgets/section_header.dart';
import 'login_page.dart';

/// 社区页面（论坛系统） - 小米风格现代化设计
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController();

  List<SectionModel> _sections = [];
  List<PostModel> _recommendedPosts = [];
  List<PostModel> _latestPosts = [];

  bool _isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  /// 加载数据
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 并行加载多个数据
      await Future.wait([
        _loadSections(),
        _loadRecommendedPosts(),
        _loadLatestPosts(),
      ]);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _refreshController.refreshCompleted();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _refreshController.refreshFailed();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载失败: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// 加载板块列表
  Future<void> _loadSections() async {
    try {
      final response = await ApiService().getSectionList();
      if (response.isSuccess && response.data != null) {
        if (mounted) {
          setState(() {
            _sections = response.data!.list;
          });
        }
      }
    } catch (e) {
      debugPrint('加载板块失败: $e');
    }
  }

  /// 加载推荐帖子
  Future<void> _loadRecommendedPosts() async {
    try {
      final response = await ApiService().getRecommendedPosts(
        page: 1,
        limit: 10,
      );
      if (response.isSuccess && response.data != null) {
        if (mounted) {
          setState(() {
            _recommendedPosts = response.data!.list;
          });
        }
      }
    } catch (e) {
      debugPrint('加载推荐帖子失败: $e');
    }
  }

  /// 加载最新帖子
  Future<void> _loadLatestPosts() async {
    try {
      final response = await ApiService().getPostsList(
        sort: 'create_time',
        sortOrder: 'desc',
        page: 1,
        limit: 10,
      );
      if (response.isSuccess && response.data != null) {
        if (mounted) {
          setState(() {
            _latestPosts = response.data!.list;
          });
        }
      }
    } catch (e) {
      debugPrint('加载最新帖子失败: $e');
    }
  }

  /// 加载更多
  Future<void> _loadMore() async {
    try {
      _currentPage++;
      final response = await ApiService().getPostsList(
        sort: 'create_time',
        sortOrder: 'desc',
        page: _currentPage,
        limit: 10,
      );

      if (response.isSuccess && response.data != null) {
        if (mounted) {
          setState(() {
            _latestPosts.addAll(response.data!.list);
          });
        }
        _refreshController.loadComplete();
      } else {
        _refreshController.loadFailed();
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('社区'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: 搜索功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              if (userProvider.isLoggedIn) {
                // TODO: 发帖页面
              } else {
                _showLoginDialog();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '板块'),
            Tab(text: '推荐'),
            Tab(text: '最新'),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSectionsTab(),
                _buildRecommendedTab(),
                _buildLatestTab(),
              ],
            ),
    );
  }

  /// 构建板块标签页
  Widget _buildSectionsTab() {
    if (_sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.category_outlined,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无板块数据',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _loadData,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _sections.length,
          itemBuilder: (context, index) {
            final section = _sections[index];
            return SectionHeader(
              section: section,
              onTap: () {
                // TODO: 跳转到板块详情
                debugPrint('点击板块: ${section.name}');
              },
            );
          },
        ),
      ),
    );
  }

  /// 构建推荐标签页
  Widget _buildRecommendedTab() {
    if (_recommendedPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.article_outlined,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无推荐帖子',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _loadData,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: _recommendedPosts.length,
          itemBuilder: (context, index) {
            final post = _recommendedPosts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                post: post,
                onTap: () {
                  // TODO: 跳转到帖子详情
                  debugPrint('点击帖子: ${post.title}');
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建最新标签页
  Widget _buildLatestTab() {
    if (_latestPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.article_outlined,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无最新帖子',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _loadData,
      onLoading: _loadMore,
      enablePullUp: true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: _latestPosts.length,
          itemBuilder: (context, index) {
            final post = _latestPosts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                post: post,
                onTap: () {
                  // TODO: 跳转到帖子详情
                  debugPrint('点击帖子: ${post.title}');
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 显示登录对话框
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('需要登录'),
        content: const Text('发帖需要先登录，是否前往登录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }
}

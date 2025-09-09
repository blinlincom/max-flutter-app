import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_theme.dart';
import '../providers/user_provider.dart';
import 'login_page.dart';

/// 用户个人中心页面
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoggedIn) {
            return _buildNotLoggedInView();
          }
          return _buildLoggedInView(userProvider);
        },
      ),
    );
  }

  /// 构建未登录视图
  Widget _buildNotLoggedInView() {
    return CustomScrollView(
      slivers: [
        // 应用栏
        SliverAppBar(
          expandedHeight: 200,
          backgroundColor: AppTheme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '未登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('立即登录'),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 功能菜单
        SliverToBoxAdapter(child: _buildMenuSection()),
      ],
    );
  }

  /// 构建已登录视图
  Widget _buildLoggedInView(UserProvider userProvider) {
    final user = userProvider.currentUser!;

    return CustomScrollView(
      slivers: [
        // 用户信息头部
        SliverAppBar(
          expandedHeight: 220,
          backgroundColor: AppTheme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // 背景图片
                  if (user.background?.isNotEmpty == true)
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: user.background!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3),
                        colorBlendMode: BlendMode.darken,
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),

                  // 用户信息
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userProvider.userAvatar,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white24,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white24,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        userProvider.displayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (user.isVip == true) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Text(
                                            'VIP',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.signature ?? '这个人很懒，什么都没留下',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 设置按钮
                  Positioned(
                    top: 40,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // TODO: 设置页面
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 统计信息
        SliverToBoxAdapter(child: _buildStatsSection(user)),

        // 功能菜单
        SliverToBoxAdapter(child: _buildMenuSection()),

        // 退出登录
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('退出登录'),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建统计信息区域
  Widget _buildStatsSection(user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('帖子', user.postCount ?? '0')),
          Container(width: 1, height: 40, color: AppTheme.dividerColor),
          Expanded(child: _buildStatItem('关注', user.followersCount ?? '0')),
          Container(width: 1, height: 40, color: AppTheme.dividerColor),
          Expanded(child: _buildStatItem('粉丝', user.fansCount ?? '0')),
          Container(width: 1, height: 40, color: AppTheme.dividerColor),
          Expanded(child: _buildStatItem('金币', (user.money ?? 0).toString())),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  /// 构建菜单区域
  Widget _buildMenuSection() {
    final menuItems = [
      MenuItemData(
        icon: Icons.person,
        title: '个人资料',
        onTap: () {
          // TODO: 个人资料页面
        },
      ),
      MenuItemData(
        icon: Icons.article,
        title: '我的帖子',
        onTap: () {
          // TODO: 我的帖子页面
        },
      ),
      MenuItemData(
        icon: Icons.favorite,
        title: '我的收藏',
        onTap: () {
          // TODO: 我的收藏页面
        },
      ),
      MenuItemData(
        icon: Icons.shopping_cart,
        title: '我的订单',
        onTap: () {
          // TODO: 我的订单页面
        },
      ),
      MenuItemData(
        icon: Icons.wallet,
        title: '我的钱包',
        onTap: () {
          // TODO: 我的钱包页面
        },
      ),
      MenuItemData(
        icon: Icons.help_outline,
        title: '帮助中心',
        onTap: () {
          // TODO: 帮助中心页面
        },
      ),
      MenuItemData(
        icon: Icons.info_outline,
        title: '关于我们',
        onTap: () {
          // TODO: 关于我们页面
        },
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 56),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item.icon, color: AppTheme.textSecondaryColor),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  /// 显示退出登录对话框
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              await userProvider.logout();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已退出登录'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// 菜单项数据模型
class MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItemData({required this.icon, required this.title, required this.onTap});
}

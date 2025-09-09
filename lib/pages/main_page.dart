import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';
import 'home_page.dart';
import 'community_page.dart';
import 'message_page.dart';
import 'profile_page.dart';

/// 主页面（底部导航）- 小米风格现代化设计
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  late final PageController _pageController;
  late final AnimationController _animationController;
  late final List<AnimationController> _iconAnimationControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // 为每个底部导航项创建动画控制器
    _iconAnimationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _pages = [
      const HomePage(),
      const CommunityPage(),
      const MessagePage(),
      const ProfilePage(),
    ];

    // 初始化首个图标动画
    _iconAnimationControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    for (final controller in _iconAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;

    // 触觉反馈
    HapticFeedback.lightImpact();

    // 更新动画状态
    _iconAnimationControllers[_currentIndex].reverse();
    _iconAnimationControllers[index].forward();

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          if (_currentIndex != index) {
            _iconAnimationControllers[_currentIndex].reverse();
            _iconAnimationControllers[index].forward();
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
      bottomNavigationBar: _buildModernBottomNavigationBar(),
    );
  }

  /// 构建现代化底部导航栏
  Widget _buildModernBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, '首页'),
              _buildNavItem(1, Icons.forum_rounded, Icons.forum_outlined, '社区'),
              _buildNavItem(
                2,
                Icons.chat_bubble_rounded,
                Icons.chat_bubble_outline_rounded,
                '消息',
              ),
              _buildNavItem(
                3,
                Icons.person_rounded,
                Icons.person_outline_rounded,
                '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    final animation = _iconAnimationControllers[index];

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final scale = 1.0 + (animation.value * 0.1);
          final opacity = 0.7 + (animation.value * 0.3);

          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isSelected ? activeIcon : inactiveIcon,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                      height: 1.0,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

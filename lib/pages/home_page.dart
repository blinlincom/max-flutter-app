import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/source_code_card.dart';
import '../widgets/search_bar_widget.dart';

/// 首页（源码查看与下载）
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBannerIndex = 0;

  // 轮播图数据
  final List<BannerItem> _banners = [
    BannerItem(
      image: 'https://picsum.photos/400/200?random=1',
      title: 'Flutter 开源项目',
      subtitle: '精选优质Flutter开源代码',
    ),
    BannerItem(
      image: 'https://picsum.photos/400/200?random=2',
      title: 'React Native 示例',
      subtitle: '跨平台移动应用开发',
    ),
    BannerItem(
      image: 'https://picsum.photos/400/200?random=3',
      title: 'Web前端项目',
      subtitle: '现代化Web应用源码',
    ),
  ];

  // 源码分类
  final List<CategoryItem> _categories = [
    CategoryItem(
      icon: Icons.phone_android,
      title: 'Android',
      color: Colors.green,
    ),
    CategoryItem(icon: Icons.phone_iphone, title: 'iOS', color: Colors.blue),
    CategoryItem(icon: Icons.web, title: 'Web', color: Colors.orange),
    CategoryItem(
      icon: Icons.desktop_windows,
      title: 'Desktop',
      color: Colors.purple,
    ),
    CategoryItem(icon: Icons.cloud, title: 'Backend', color: Colors.red),
    CategoryItem(icon: Icons.extension, title: 'Plugin', color: Colors.teal),
  ];

  // 热门源码
  final List<SourceCodeItem> _popularCodes = [
    SourceCodeItem(
      title: 'Flutter聊天应用',
      description: '基于Flutter开发的即时通讯应用，支持文字、图片、语音消息',
      author: '张三',
      downloads: 1250,
      rating: 4.8,
      tags: ['Flutter', 'Chat', 'Real-time'],
      image: 'https://picsum.photos/200/150?random=10',
    ),
    SourceCodeItem(
      title: 'React商城系统',
      description: '完整的电商平台前端代码，包含商品展示、购物车、订单管理等功能',
      author: '李四',
      downloads: 890,
      rating: 4.6,
      tags: ['React', 'E-commerce', 'Redux'],
      image: 'https://picsum.photos/200/150?random=11',
    ),
    SourceCodeItem(
      title: 'Vue后台管理',
      description: 'Vue3 + TypeScript开发的后台管理系统，包含权限管理、数据可视化',
      author: '王五',
      downloads: 650,
      rating: 4.7,
      tags: ['Vue3', 'TypeScript', 'Admin'],
      image: 'https://picsum.photos/200/150?random=12',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 应用栏
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.primaryColor,
            title: const Text(
              '源码分享社区',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  // TODO: 通知页面
                },
              ),
            ],
          ),

          // 内容区域
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 搜索栏
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SearchBarWidget(
                    onSearch: (keyword) {
                      // TODO: 搜索功能
                      debugPrint('搜索关键词: $keyword');
                    },
                  ),
                ),

                // 轮播图
                _buildBannerSection(),

                const SizedBox(height: 24),

                // 分类导航
                _buildCategorySection(),

                const SizedBox(height: 24),

                // 热门源码
                _buildPopularSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建轮播图区域
  Widget _buildBannerSection() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: AppConstants.bannerHeight,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          items: _banners.map((banner) {
            return Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: banner.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.dividerColor,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.dividerColor,
                            child: const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner.subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // 轮播指示器
        AnimatedSmoothIndicator(
          activeIndex: _currentBannerIndex,
          count: _banners.length,
          effect: WormEffect(
            dotColor: AppTheme.dividerColor,
            activeDotColor: AppTheme.primaryColor,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }

  /// 构建分类导航区域
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '源码分类',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    // TODO: 跳转到分类页面
                    debugPrint('点击分类: ${category.title}');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          category.icon,
                          color: category.color,
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 构建热门源码区域
  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '热门源码',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 查看更多
                },
                child: const Text('查看更多'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _popularCodes.length,
          itemBuilder: (context, index) {
            final code = _popularCodes[index];
            return SourceCodeCard(
              sourceCode: code,
              onTap: () {
                // TODO: 跳转到详情页面
                debugPrint('点击源码: ${code.title}');
              },
            );
          },
        ),
      ],
    );
  }
}

/// 轮播图数据模型
class BannerItem {
  final String image;
  final String title;
  final String subtitle;

  BannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

/// 分类数据模型
class CategoryItem {
  final IconData icon;
  final String title;
  final Color color;

  CategoryItem({required this.icon, required this.title, required this.color});
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

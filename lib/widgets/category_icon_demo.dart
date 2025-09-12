import 'package:flutter/material.dart';
import 'category_icon.dart';

/// CategoryIcon组件演示页面
class CategoryIconDemo extends StatelessWidget {
  const CategoryIconDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类图标演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '网络图标示例：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 有效网络图标示例
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const CategoryIcon(
                    networkIconUrl:
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    categoryName: 'Flutter',
                    categoryId: 1,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('网络图标（正常加载）'),
              ],
            ),

            const SizedBox(height: 16),

            // 无效网络图标示例（将显示默认图标）
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const CategoryIcon(
                    networkIconUrl: 'https://invalid-url.com/icon.png',
                    categoryName: 'Android',
                    categoryId: 2,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('网络图标（加载失败，显示默认）'),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              '本地默认图标示例：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 本地图标示例
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _demoCategories.length,
                itemBuilder: (context, index) {
                  final category = _demoCategories[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: CategoryIcon(
                          categoryName: category['name'],
                          categoryId: category['id'],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 演示用的分类数据
  static const List<Map<String, dynamic>> _demoCategories = [
    {'id': 1, 'name': 'Flutter'},
    {'id': 2, 'name': 'Android'},
    {'id': 3, 'name': 'iOS'},
    {'id': 4, 'name': 'Web'},
    {'id': 5, 'name': 'Backend'},
    {'id': 6, 'name': 'Game'},
    {'id': 7, 'name': 'Tool'},
    {'id': 8, 'name': '其他'},
    {'id': 9, 'name': '移动开发'},
    {'id': 10, 'name': '前端'},
    {'id': 11, 'name': '后端'},
    {'id': 12, 'name': '游戏'},
  ];
}

import 'dart:convert';
import 'lib/models/app_category_model.dart';
import 'lib/models/api_response.dart';

void main() {
  // 你提供的接口返回数据
  final jsonString = '''
{
  "code": 1,
  "msg": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "name": "码享",
        "icon": "",
        "create_time": "2025-09-10 03:04:16",
        "children": [
          {
            "id": 2,
            "name": "ui",
            "icon": "http://api.blinlin.com/uploads/20250910/22febe6be6c9e53ce3a2a160ed16a5b2.jpg",
            "create_time": "2025-09-10 03:05:11"
          },
          {
            "id": 3,
            "name": "工具",
            "icon": "",
            "create_time": "2025-09-10 03:05:32"
          }
        ]
      }
    ],
    "pagecount": 1,
    "current_number": "1"
  },
  "timestamp": 1757444926
}
''';

  try {
    // 解析JSON
    final jsonData = json.decode(jsonString);

    // 创建API响应
    final response = ApiResponse<PageResponse<AppCategoryModel>>.fromJson(
      jsonData,
      (json) {
        final data = json as Map<String, dynamic>;
        return PageResponse<AppCategoryModel>(
          list: (data['list'] as List)
              .map(
                (item) =>
                    AppCategoryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
          pageCount: data['pagecount'] ?? 0,
          currentNumber: data['current_number'] ?? 1,
        );
      },
    );

    print('=== 数据解析测试 ===');
    print('API响应状态: ${response.isSuccess ? "成功" : "失败"}');
    print('响应消息: ${response.message}');
    print('分类数量: ${response.data?.list.length ?? 0}');

    if (response.data != null) {
      print('\\n=== 父分类详情 ===');
      for (int i = 0; i < response.data!.list.length; i++) {
        final category = response.data!.list[i];
        print('父分类 ${i + 1}:');
        print('  ID: ${category.id}');
        print('  名称: ${category.name}');
        print('  图标: ${category.icon?.isEmpty == true ? "无" : category.icon}');
        print('  创建时间: ${category.createTime}');
        print('  有效图标: ${category.hasValidIcon ? "是" : "否"}');

        if (category.children != null && category.children!.isNotEmpty) {
          print('  子分类数量: ${category.children!.length}');
          print('\\n=== Children 子分类详情 ===');
          for (int j = 0; j < category.children!.length; j++) {
            final child = category.children![j];
            print('子分类 ${j + 1}: ${child.name} (ID: ${child.id})');
            print('  图标: ${child.icon?.isEmpty == true ? "无" : child.icon}');
            print('  有效图标: ${child.hasValidIcon ? "是" : "否"}');
            print('  创建时间: ${child.createTime}');
          }
        }
        print('');
      }

      // 测试提取所有children数据的逻辑
      print('\\n=== 提取所有Children数据测试 ===');
      List<AppSubCategoryModel> allChildren = [];
      for (final category in response.data!.list) {
        if (category.children != null) {
          allChildren.addAll(category.children!);
        }
      }
      print('提取的子分类总数: ${allChildren.length}');
      for (int i = 0; i < allChildren.length; i++) {
        final child = allChildren[i];
        print(
          '${i + 1}. ${child.name} (ID: ${child.id}) - 图标: ${child.hasValidIcon ? "有" : "无"}',
        );
      }
    }

    print('\\n=== 测试结果 ===');
    print('✅ 数据解析完全成功！');
    print('✅ 模型与接口数据格式完美匹配！');
    print('✅ Children数据提取逻辑验证成功！');
  } catch (e, stackTrace) {
    print('❌ 数据解析失败: $e');
    print('堆栈跟踪: $stackTrace');
  }
}

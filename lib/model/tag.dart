import 'package:jtech_base/jtech_base.dart';

/*
* 标签模型
* @author wuxubaiyang
* @Time 2025/3/27 0:24
*/
class TagModel extends BaseModel {
  // 标签
  final String tag;

  // 地址
  final String href;

  // 数量
  final int count;

  // 分类集合
  final List<String> types;

  TagModel({
    required this.tag,
    required this.href,
    required this.count,
    this.types = const [],
  });

  @override
  TagModel.from(obj)
    : tag = obj?['tag'] ?? '',
      href = obj?['href'] ?? '',
      count = obj?['href'] ?? '',
      types = obj?['types'] ?? [];

  @override
  Map<String, dynamic> to() => {
    'tag': tag,
    'href': href,
    'count': count,
    'types': types,
  };
}

// 标签排序方式
enum TagSortType {
  // 名称
  name,
  // 更新日期
  update,
  // 类型
  type,
  // 总数
  count,
}

// 扩展标签排序方式枚举
extension TagSortTypeExtension on TagSortType {
  // 获取排序字段
  String get label =>
      {
        TagSortType.name: '默认',
        TagSortType.update: '更新',
        TagSortType.type: '分类',
        TagSortType.count: '总数',
      }[this] ??
      '';

  // 值
  String get value =>
      {
        TagSortType.name: 'tag',
        TagSortType.update: 'updated',
        TagSortType.type: 'type',
        TagSortType.count: 'index_count',
      }[this] ??
      '';
}

// 排序方式枚举
enum SortType {
  // 升序
  asc,
  // 降序
  desc,
}

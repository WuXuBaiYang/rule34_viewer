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

  TagModel({required this.tag, required this.href, required this.count});

  @override
  TagModel.from(obj)
    : tag = obj?['tag'] ?? '',
      href = obj?['href'] ?? '',
      count = obj?['href'] ?? '';

  @override
  Map<String, dynamic> to() => {'tag': tag, 'href': href, 'count': count};
}

import 'package:flutter/material.dart';

/*
* 标签列表
* @author wuxubaiyang
* @Time 2025/3/28 0:57
*/
class TagList extends StatelessWidget {
  // 标签列表
  final List<String> tagList;

  const TagList({super.key, required this.tagList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 6,
        children: [
          if (tagList.isEmpty) _buildTag(context, 'all'),
          ...List.generate(tagList.length, (i) {
            return _buildTag(context, tagList[i]);
          }),
        ],
      ),
    );
  }

  // 构建标签项
  Widget _buildTag(BuildContext context, String tag) {
    return RawChip(label: Text(tag));
  }
}

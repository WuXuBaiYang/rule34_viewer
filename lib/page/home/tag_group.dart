import 'package:flutter/material.dart';

/*
* 标签组
* @author wuxubaiyang
* @Time 2025/3/28 0:57
*/
class TagGroup extends StatelessWidget {
  // 标签列表
  final List<String> tagList;

  // 删除回调
  final ValueChanged<String>? onDelete;

  const TagGroup({super.key, required this.tagList, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Row(
        spacing: 6,
        children: List.generate(tagList.length, (i) {
          return _buildTag(context, tagList[i]);
        }),
      ),
    );
  }

  // 构建标签项
  Widget _buildTag(BuildContext context, String tag) {
    return RawChip(
      label: Text(tag),
      labelStyle: TextTheme.of(context).labelSmall,
      onDeleted: onDelete != null ? () => onDelete!(tag) : null,
    );
  }
}

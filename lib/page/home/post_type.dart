import 'package:flutter/material.dart';

/*
* 帖子类型标签集合
* @author wuxubaiyang
* @Time 2025/3/28 11:08
*/
class PostTypeTagGroup extends StatelessWidget {
  // 当权选中类型
  final PostType? selectedType;

  // 选择回调
  final ValueChanged<PostType?> onSelected;

  const PostTypeTagGroup({
    super.key,
    required this.onSelected,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final types = PostType.values;
    return Wrap(
      spacing: 6,
      children: List.generate(types.length, (i) {
        return _buildTag(types[i]);
      }),
    );
  }

  // 构建标签项
  Widget _buildTag(PostType type) {
    return ChoiceChip(
      label: Text(type.name),
      selected: selectedType == type,
      onSelected: (selected) => onSelected(selected ? type : null),
    );
  }
}

// 帖子资源类型
enum PostType { image, video }

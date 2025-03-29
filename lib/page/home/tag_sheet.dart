import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/page/home/tag_list.dart';

/*
* 自定义tag底部弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:32
*/
Future<List<String>?> showCustomTagSheet(
  BuildContext context, {
  required List<String> tags,
}) {
  return showModalBottomSheet(
    context: context,
    scrollControlDisabledMaxHeightRatio: 0.9,
    builder: (_) => CustomTagSheet(tags: tags),
  );
}

/*
* 自定义tag弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:35
*/
class CustomTagSheet extends ProviderView<CustomTagSheetProvider> {
  // tag集合
  final List<String> tags;

  CustomTagSheet({super.key, required this.tags});

  @override
  CustomTagSheetProvider createProvider(BuildContext context) =>
      CustomTagSheetProvider(context, tags);

  @override
  Widget buildWidget(BuildContext context) {
    return BottomSheet(
      clipBehavior: Clip.hardEdge,
      onClosing: () {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: CloseButton(),
            title: _buildTagList(),
            actions: [
              IconButton(
                onPressed: () => context.pop(provider.tags),
                icon: Icon(Icons.check),
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
            child: Column(children: [_buildSearchBar()]),
          ),
        );
      },
    );
  }

  // 构建搜索条
  Widget _buildSearchBar() {
    return SearchBar(
      hintText: '搜索标签 仅英文',
    );
  }

  // 构建标签列表
  Widget _buildTagList() {
    return createSelector<List<String>>(
      selector: (_, p) => p.tags,
      builder: (_, tags, __) {
        if (tags.isEmpty) return Text('管理标签');
        return TagList(tagList: tags);
      },
    );
  }
}

class CustomTagSheetProvider extends BaseProvider {
  // tag集合
  List<String> tags;

  CustomTagSheetProvider(super.context, this.tags);
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'package:rule34_viewer/page/home/tag_list.dart';

/*
* 自定义tag底部弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:32
*/
Future<List<String>?> showCustomTagSheet(
  BuildContext context, {
  required List<String> selectedTags,
}) {
  return showModalBottomSheet(
    context: context,
    scrollControlDisabledMaxHeightRatio: 0.9,
    builder: (_) => CustomTagSheet(selectedTags: selectedTags),
  );
}

/*
* 自定义tag弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:35
*/
class CustomTagSheet extends ProviderView<CustomTagSheetProvider> {
  // tag集合
  final List<String> selectedTags;

  CustomTagSheet({super.key, required this.selectedTags});

  @override
  CustomTagSheetProvider createProvider(BuildContext context) =>
      CustomTagSheetProvider(context, selectedTags);

  @override
  Widget buildWidget(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      clipBehavior: Clip.hardEdge,
      onClosing: () {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: CloseButton(),
            title: createSelector<List<String>>(
              selector: (_, p) => p.selectedTags,
              builder: (_, tags, __) {
                if (tags.isEmpty) return Text('管理标签');
                return TagList(tagList: tags);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => context.pop(provider.selectedTags),
                icon: Icon(Icons.check),
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_buildSearchBar(), Expanded(child: _buildTagList())],
            ),
          ),
        );
      },
    );
  }

  // 构建搜索条
  Widget _buildSearchBar() {
    return SearchBar(
      autoFocus: true,
      hintText: '搜索标签 仅英文',
      controller: provider.searchController,
      onSubmitted: (_) => provider.controller.startRefresh(),
    );
  }

  // 构建标签列表
  Widget _buildTagList() {
    return createSelector<List<String>>(
      builder: (_, selectedTags, __) {
        return CustomRefreshView(
          controller: provider.controller,
          onRefreshLoad: provider.loadTagList,
          builder: (_, tagList) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Wrap(
                spacing: 8,
                runSpacing: 14,
                children: List.generate(tagList.length, (i) {
                  final item = tagList[i];
                  return ChoiceChip(
                    label: Text('${item.tag} (${item.count})'),
                    selected: selectedTags.contains(item.tag),
                    onSelected: (_) => provider.selectTag(item.tag),
                  );
                }),
              ),
            );
          },
        );
      },
      selector: (_, p) => p.selectedTags,
    );
  }
}

class CustomTagSheetProvider extends BaseProvider {
  // tag集合
  List<String> selectedTags;

  // 标签列表控制器
  final controller = CustomRefreshController<TagModel>.empty();

  // 搜索控制器
  final searchController = TextEditingController();

  // 排序方式
  SortType sortType = SortType.asc;

  // 搜索类型
  TagSortType tagSortType = TagSortType.update;

  CustomTagSheetProvider(super.context, this.selectedTags);

  // 选择/取消选择标签
  void selectTag(String tag) {
    selectedTags = List.from(selectedTags, growable: true);
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    notifyListeners();
  }

  // 加载数据
  void loadTagList(bool loadMore) async {
    final result = await api.loadTagList(
      tags: searchController.text.split(' '),
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
      sort: sortType,
      type: tagSortType,
    );
    controller.finish(result, loadMore);
  }
}

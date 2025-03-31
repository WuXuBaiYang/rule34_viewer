import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/home/post_grid.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
import 'package:window_manager/window_manager.dart';

/*
* 搜索页面(桌面端)
* @author wuxubaiyang
* @Time 2025/3/31 17:32
*/
class SearchDesktopPage extends ProviderPage<SearchDesktopProvider> {
  SearchDesktopPage({super.key, super.state});

  @override
  SearchDesktopProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => SearchDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(title: Text('搜索')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildPostGridList(context)),
        ],
      ),
    );
  }

  // 构建搜索条
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(14),
      child: SearchBar(
        autoFocus: true,
        hintText: '帖子搜索',
        controller: provider.searchController,
        onSubmitted: (_) => provider.controller.startRefresh(),
        trailing: [
          ValueListenableBuilder(
            valueListenable: provider.searchController,
            builder: (_, value, __) {
              if (value.text.isEmpty) return SizedBox();
              return IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 14,
                onPressed: () {
                  provider.searchController.clear();
                  provider.controller.startRefresh();
                },
                icon: Icon(Icons.close_rounded),
              );
            },
          ),
          IconButton(
            onPressed: provider.controller.startRefresh,
            icon: Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }

  // 构建帖子列表
  Widget _buildPostGridList(BuildContext context) {
    return createSelector3<int, List<String>, int?>(
      selector: (_, p) => (p.columnCount, p.collectPostIds, p.hoverIndex),
      builder: (_, columnCount, collectPostIds, hoverIndex, __) {
        return PostGridList(
          onTap: router.goPost,
          hoverIndex: hoverIndex,
          collectPostIds: collectPostIds,
          onCollect: provider.collectPost,
          onHoverIndex: provider.updateHoverIndex,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 180,
            crossAxisCount: columnCount,
          ),
          controller: provider.controller,
          onRefreshLoad: provider.loadPostList,
          padding: EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 14),
        );
      },
    );
  }
}

class SearchDesktopProvider extends PageProvider with WindowListener {
  // 搜索控制器
  final searchController = TextEditingController();

  // 帖子控制器
  final controller = CustomRefreshController<PostModel>.empty(pageSize: 42);

  // 默认列宽
  late final columnWidth = windowSize.width / columnCount;

  // 帖子列数
  int columnCount = 5;

  // 已收藏帖子id集合
  late List<String> collectPostIds = List.from(
    database.getAllCollectPostIds(),
    growable: true,
  );

  // 记录当前hover的index
  int? hoverIndex;

  SearchDesktopProvider(super.context, super.state) {
    // 监听窗口变化
    windowManager.addListener(this);
  }

  // 加载帖子列表
  void loadPostList(bool loadMore) async {
    final result = await api.loadPostList(
      tags: searchController.text.split(' '),
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
    );
    controller.finish(result, loadMore);
  }

  // 收藏/取消收藏帖子
  void collectPost(PostModel value) {
    if (collectPostIds.contains(value.id)) {
      collectPostIds.remove(value.id);
      database.unCollectPost(value);
    } else {
      collectPostIds.add(value.id);
      database.collectPost(value);
    }
    collectPostIds = List.from(collectPostIds, growable: true);
    notifyListeners();
  }

  // 更新当前hover的index
  void updateHoverIndex(int? index) {
    hoverIndex = index;
    notifyListeners();
  }

  @override
  void onWindowResize() async {
    final windowSize = await windowManager.getSize();
    columnCount = windowSize.width ~/ columnWidth;
    notifyListeners();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}

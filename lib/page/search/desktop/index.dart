import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/post/desktop/index.dart';
import 'package:rule34_viewer/widget/appbar_desktop.dart';
import 'package:rule34_viewer/widget/post_grid_desktop.dart';

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
    return createSelector<List<String>>(
      selector: (_, p) => p.collectPostIds,
      builder: (_, collectPostIds, __) {
        return DesktopPostGridList(
          onTap: provider.goPost,
          collectPostIds: collectPostIds,
          onCollect: provider.collectPost,
          controller: provider.controller,
          onRefreshLoad: provider.loadPostList,
        );
      },
    );
  }
}

class SearchDesktopProvider extends PageProvider {
  // 搜索控制器
  final searchController = TextEditingController();

  // 帖子控制器
  final controller = CustomRefreshController<PostModel>.empty(pageSize: 42);

  // 已收藏帖子id集合
  late List<String> collectPostIds = List.from(
    database.getAllCollectPostIds(),
    growable: true,
  );

  SearchDesktopProvider(super.context, super.state) {
    // 获取初始搜索标签
    final initialSearch = find('search');
    if (initialSearch == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = initialSearch;
      controller.startRefresh();
    });
  }

  // 获取搜索标签集合
  List<String> get searchTags => searchController.text.split(' ');

  // 加载帖子列表
  void loadPostList(bool loadMore) async {
    final result = await api.loadPostList(
      tags: searchTags,
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
    );
    controller.finish(result, loadMore);
  }

  // 收藏/取消收藏帖子
  void collectPost(PostModel v) async {
    if (collectPostIds.contains(v.id)) {
      collectPostIds.remove(v.id);
      database.unCollectPost(v.id);
    } else {
      collectPostIds.add(v.id);
      await database.collectPost(v);
    }
    _refreshCollect();
  }

  // 跳转到帖子详情
  void goPost(PostModel v) async {
    await showPostDesktopDialog(context, postInfo: v);
    _refreshCollect();
  }

  // 刷新收藏列表
  void _refreshCollect() {
    collectPostIds = List.from(database.getAllCollectPostIds(), growable: true);
    notifyListeners();
  }
}

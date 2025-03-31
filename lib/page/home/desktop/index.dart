import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/home/post_grid.dart';
import 'package:rule34_viewer/page/home/tag_sheet.dart';
import 'package:rule34_viewer/page/home/tag_group.dart';
import 'package:rule34_viewer/provider/config.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
import 'package:rule34_viewer/widget/divider.dart';
import 'package:window_manager/window_manager.dart';

/*
* 首页(桌面端)
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomeDesktopPage extends ProviderPage<HomeDesktopPageProvider> {
  HomeDesktopPage({super.key, super.state});

  @override
  HomeDesktopPageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomeDesktopPageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(title: Text('Rule34Viewer')),
      body: Column(
        children: [
          _buildTags(context),
          Expanded(child: _buildPostGridList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.theme.changeThemeMode(
            context.theme.themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }

  // 构建标签集合
  Widget _buildTags(BuildContext context) {
    final dividerSize = Size(20, 20);
    return Selector<ConfigProvider, List<String>>(
      selector: (_, p) => p.tagList,
      builder: (_, tagList, __) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Selector<ConfigProvider, bool>(
                builder: (_, isVideoOnly, __) {
                  return ChoiceChip(
                    label: Text('仅视频'),
                    showCheckmark: false,
                    selected: isVideoOnly,
                    onSelected: provider.updateVideoOnly,
                    labelStyle: TextTheme.of(context).labelSmall,
                  );
                },
                selector: (_, p) => p.isVideoOnly,
              ),
              if (tagList.isNotEmpty) ...[
                CustomVerticalDivider(size: dividerSize),
                Expanded(child: TagGroup(tagList: tagList)),
                CustomVerticalDivider(size: dividerSize),
              ] else
                Spacer(),
              IconButton(
                onPressed: provider.updateTags,
                icon: Icon(Icons.filter_alt_outlined),
              ),
              IconButton(
                onPressed: provider.goCollect,
                icon: Icon(Icons.star_outline_rounded),
              ),
              IconButton(
                onPressed: provider.goSearch,
                icon: Icon(Icons.search),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建帖子列表
  Widget _buildPostGridList(BuildContext context) {
    return createSelector3<int, List<String>, int?>(
      selector: (_, p) => (p.columnCount, p.collectPostIds, p.hoverIndex),
      builder: (_, columnCount, collectPostIds, hoverIndex, __) {
        return PostGridList(
          onTap: provider.goPost,
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

class HomeDesktopPageProvider extends PageProvider with WindowListener {
  // 帖子控制器
  final controller = CustomRefreshController<PostModel>.empty(pageSize: 42);

  // 默认列宽
  late final columnWidth = windowSize.width / columnCount;

  // 帖子列数
  int columnCount = 5;

  // 全局配置
  late final ConfigProvider _config = context.config;

  // 已收藏帖子id集合
  late List<String> collectPostIds = List.from(
    database.getAllCollectPostIds(),
    growable: true,
  );

  // 记录当前hover的index
  int? hoverIndex;

  HomeDesktopPageProvider(super.context, super.state) {
    // 监听窗口变化
    windowManager.addListener(this);
  }

  // 加载帖子列表
  void loadPostList(bool loadMore) async {
    final result = await api.loadPostList(
      tags: [if (_config.isVideoOnly) 'video', ..._config.tagList],
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
    );
    controller.finish(result, loadMore);
  }

  // 更新标签
  void updateTags() async {
    final result = await showCustomTagSheet(
      context,
      selectedTags: _config.tagList,
    );
    if (result == null) return;
    _config.setTags(result);
    controller.startRefresh();
  }

  // 更新仅视频
  void updateVideoOnly(bool value) {
    _config.setVideoOnly(value);
    controller.startRefresh();
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

  // 跳转到帖子详情
  void goPost(PostModel value) async {
    await router.goPost(value);
    _refreshCollect();
  }

  // 跳转到收藏列表
  void goCollect() async {
    await router.goCollect();
    _refreshCollect();
  }

  // 跳转到搜索列表
  void goSearch() async {
    await router.goSearch();
    _refreshCollect();
  }

  // 刷新收藏列表
  void _refreshCollect() {
    collectPostIds = List.from(database.getAllCollectPostIds(), growable: true);
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

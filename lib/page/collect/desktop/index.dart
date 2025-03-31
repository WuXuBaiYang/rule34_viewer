import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/home/post_grid.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
import 'package:window_manager/window_manager.dart';

/*
* 收藏页面(桌面端)
* @author wuxubaiyang
* @Time 2025/3/31 17:32
*/
class CollectDesktopPage extends ProviderPage<CollectDesktopProvider> {
  CollectDesktopPage({super.key, super.state});

  @override
  CollectDesktopProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => CollectDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(title: Text('收藏')),
      body: _buildCollectGridList(context),
    );
  }

  // 构建收藏帖子列表
  Widget _buildCollectGridList(BuildContext context) {
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
          padding: EdgeInsets.all(14),
          controller: provider.controller,
          onRefreshLoad: provider.loadCollectList,
        );
      },
    );
  }
}

class CollectDesktopProvider extends PageProvider with WindowListener {
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

  CollectDesktopProvider(super.context, super.state) {
    // 监听窗口变化
    windowManager.addListener(this);
  }

  // 加载收藏列表
  void loadCollectList(bool loadMore) async {
    final result =
        database
            .getCollectList(
              pageIndex: controller.getPage(loadMore),
              pageSize: controller.pageSize,
            )
            .where((e) => e.postInfo != null)
            .map<PostModel>((e) => e.postInfo!)
            .toList();
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

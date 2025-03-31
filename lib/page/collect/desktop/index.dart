import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
import 'package:rule34_viewer/widget/post_grid_desktop.dart';

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
    return createSelector<List<String>>(
      selector: (_, p) => p.collectPostIds,
      builder: (_, collectPostIds, __) {
        return DesktopPostGridList(
          onTap: router.goPost,
          collectPostIds: collectPostIds,
          onCollect: provider.collectPost,
          controller: provider.controller,
          onRefreshLoad: provider.loadCollectList,
        );
      },
    );
  }
}

class CollectDesktopProvider extends PageProvider {
  // 帖子控制器
  final controller = CustomRefreshController<PostModel>.empty(pageSize: 42);

  // 已收藏帖子id集合
  late List<String> collectPostIds = List.from(
    database.getAllCollectPostIds(),
    growable: true,
  );

  CollectDesktopProvider(super.context, super.state);

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
}

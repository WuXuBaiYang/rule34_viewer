import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/database/model/collect.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'package:rule34_viewer/widget/appbar_desktop.dart';
import 'package:rule34_viewer/widget/collect_post_grid_desktop.dart';

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
    return DesktopCollectPostGridList(
      onCollect: provider.collectPost,
      controller: provider.controller,
      onRefreshLoad: provider.loadCollectList,
      onTap: (v) => router.goPostByCollect(v, provider.sort),
    );
  }
}

class CollectDesktopProvider extends PageProvider {
  // 帖子控制器
  final controller = CustomRefreshController<CollectEntity>.empty(pageSize: 99);

  // 排序类型
  SortType sort = SortType.desc;

  CollectDesktopProvider(super.context, super.state);

  // 加载收藏列表
  void loadCollectList(bool loadMore) async {
    final result = database.getCollectList(
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
      sort: sort,
    );
    controller.finish(result, loadMore);
  }

  // 收藏/取消收藏帖子
  void collectPost(CollectEntity v) {
    if (controller.value.data.any((e) => v == e)) {
      database.unCollectPost(v.postId);
      controller.remove(v);
    } else {
      database.collectPost(v.postInfo);
      controller.add(v);
    }
  }
}

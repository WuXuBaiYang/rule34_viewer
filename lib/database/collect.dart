import 'dart:math';

import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/objectbox.g.dart';
import 'model/collect.dart';

/*
* 收藏夹数据库
* @author wuxubaiyang
* @Time 2025/3/27 14:25
*/
mixin CollectDatabase on BaseDatabase {
  // 收藏表
  late final collectBox = getBox<CollectEntity>();

  // 收藏帖子
  Future<CollectEntity> collectPost(PostModel postInfo) =>
      collectBox.putAndGetAsync(
        CollectEntity()
          ..collectTime = DateTime.now()
          ..postInfo = postInfo,
      );

  // 取消帖子收藏
  bool unCollectPost(CollectEntity entity) => collectBox.remove(entity.id);

  // 分页获取收藏列表
  List<CollectEntity> getCollectList({int pageIndex = 1, int pageSize = 15}) {
    final query =
        collectBox
            .query()
            .order(CollectEntity_.collectTime, flags: Order.descending)
            .build()
          ..offset = max(0, pageIndex - 1) * pageSize
          ..limit = pageSize;
    return query.find();
  }
}

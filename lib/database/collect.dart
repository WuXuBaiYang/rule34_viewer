import 'dart:math';

import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';
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
          ..postId = postInfo.id
          ..collectTime = DateTime.now()
          ..postInfo = postInfo,
      );

  // 取消帖子收藏
  void unCollectPost(PostModel postInfo) =>
      collectBox
          .query(CollectEntity_.postId.equals(postInfo.id))
          .build()
          .remove();

  // 分页获取收藏列表
  List<CollectEntity> getCollectList({
    int pageIndex = 1,
    int pageSize = 15,
    SortType sort = SortType.desc,
  }) {
    final desc = sort == SortType.desc;
    final sortFlags = desc ? Order.descending : 0;
    final query =
        collectBox
            .query()
            .order(CollectEntity_.collectTime, flags: sortFlags)
            .build()
          ..offset = max(0, pageIndex - 1) * pageSize
          ..limit = pageSize;
    return query.find();
  }

  // 获取所有已收藏的帖子id
  List<String> getAllCollectPostIds() => collectBox
      .query()
      .build()
      .find()
      .map((e) => e.postId)
      .toList(growable: false);

  // 根据当前收藏夹id获取上一条/下一条收藏信息
  CollectEntity? getCollectNavigator(
    CollectEntity collectInfo, {
    bool isNext = true,
    SortType sort = SortType.desc,
  }) {
    final desc = sort == SortType.desc;
    final postDate = collectInfo.collectTime;
    final sortFlags = desc ? Order.descending : 0;
    final condition =
        isNext
            ? CollectEntity_.collectTime.greaterThanDate(postDate)
            : CollectEntity_.collectTime.lessThanDate(postDate);
    final query =
        collectBox
            .query(condition)
            .order(CollectEntity_.collectTime, flags: sortFlags)
            .build()
          ..limit = 1;
    return query.findFirst();
  }
}

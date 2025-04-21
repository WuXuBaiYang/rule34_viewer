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
          ..href = postInfo.href
          ..isVideo = postInfo.isVideo
          ..thumbUrl = postInfo.thumbUrl,
      );

  // 取消帖子收藏
  void unCollectPost(String postId) =>
      collectBox.query(CollectEntity_.postId.equals(postId)).build().remove();

  // 检查帖子是否已收藏
  bool isPostCollected(String postId) =>
      collectBox.query(CollectEntity_.postId.equals(postId)).build().count() >
      0;

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

  // 判断是否存在上一条收藏
  bool hasPrevCollect(
    CollectEntity collectInfo, {
    SortType sort = SortType.desc,
  }) => getCollectNavigator(collectInfo, isNext: false, sort: sort) != null;

  // 判断是否存在下一条收藏
  bool hasNextCollect(
    CollectEntity collectInfo, {
    SortType sort = SortType.desc,
  }) => getCollectNavigator(collectInfo, isNext: true, sort: sort) != null;

  // 根据当前收藏夹id获取上一条/下一条收藏信息
  CollectEntity? getCollectNavigator(
    CollectEntity collectInfo, {
    bool isNext = true,
    SortType sort = SortType.desc,
  }) {
    final isDesc = sort == SortType.desc;
    final postDate = collectInfo.collectTime;
    final sortFlags = isDesc ? Order.descending : 0;
    final less = CollectEntity_.collectTime.lessThanDate(postDate);
    final greater = CollectEntity_.collectTime.greaterThanDate(postDate);
    final query =
        collectBox
            .query(
              isDesc ? (isNext ? less : greater) : (isNext ? greater : less),
            )
            .order(CollectEntity_.collectTime, flags: sortFlags)
            .build()
          ..limit = 1;
    return query.findFirst();
  }
}

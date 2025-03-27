import 'dart:convert';

import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/post.dart';

/*
* 收藏夹数据库
* @author wuxubaiyang
* @Time 2025/3/27 14:29
*/
@Entity()
class CollectEntity {
  int id = 0;

  // 收藏时间
  @Property(type: PropertyType.date)
  DateTime collectTime = DateTime.now();

  // 帖子信息
  @Transient()
  PostModel? postInfo;

  String get dbPostInfo => jsonEncode(postInfo?.to());

  set dbPostInfo(String v) => postInfo = PostModel.from(jsonDecode(v));

  CollectEntity();
}

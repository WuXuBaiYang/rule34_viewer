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

  // 帖子id
  String postId = '';

  // 帖子href
  String href = '';

  // 缩略图
  String thumbUrl = '';

  // 是否为视频
  bool isVideo = false;

  CollectEntity();

  // 生成帖子信息
  @Transient()
  PostModel get postInfo => PostModel.simple(
    id: postId,
    href: href,
    isVideo: isVideo,
    thumbUrl: thumbUrl,
  );
}

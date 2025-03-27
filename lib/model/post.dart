import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/tag.dart';

/*
* 帖子模型
* @author wuxubaiyang
* @Time 2025/3/27 0:04
*/
class PostModel extends BaseModel {
  // 帖子id
  final String id;

  // 缩略图
  final String thumbUrl;

  // 详情地址
  final String href;

  // 是否为视频
  final bool isVideo;

  // 资源地址
  final String sourceUrl;

  // 图片宽度
  final int width;

  // 图片高度
  final int height;

  // 帖子信息
  final PostInfo? postInfo;

  PostModel({
    required this.id,
    required this.thumbUrl,
    required this.href,
    required this.isVideo,
    required this.sourceUrl,
    required this.width,
    required this.height,
    required this.postInfo,
  });

  // 简略信息
  PostModel.simple({
    required this.id,
    required this.thumbUrl,
    required this.href,
    required this.isVideo,
  }) : sourceUrl = '',
       width = -1,
       height = -1,
       postInfo = null;

  // 是否包含帖子详情
  bool get hasPostInfo => postInfo != null;

  @override
  PostModel.from(obj)
    : id = obj?['id'] ?? '',
      thumbUrl = obj?['thumbUrl'] ?? '',
      href = obj?['href'] ?? '',
      isVideo = obj?['isVideo'] ?? false,
      sourceUrl = obj?['sourceUrl'] ?? '',
      width = obj?['width'] ?? 0,
      height = obj?['height'] ?? 0,
      postInfo = PostInfo.from(obj?['postInfo']);

  @override
  Map<String, dynamic> to() => {
    'id': id,
    'thumbUrl': thumbUrl,
    'href': href,
    'isVideo': isVideo,
    'sourceUrl': sourceUrl,
    'width': width,
    'height': height,
    'postInfo': postInfo?.to(),
  };

  @override
  PostModel copyWith({
    String? id,
    String? thumbUrl,
    String? href,
    bool? isVideo,
    String? sourceUrl,
    int? width,
    int? height,
    PostInfo? postInfo,
  }) {
    return PostModel(
      id: id ?? this.id,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      href: href ?? this.href,
      isVideo: isVideo ?? this.isVideo,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      postInfo: postInfo ?? this.postInfo,
    );
  }
}

/*
* 帖子信息
* @author wuxubaiyang
* @Time 2025/3/27 0:17
*/
class PostInfo extends BaseModel {
  // 发布时间
  final DateTime postTime;

  // 发布人
  final String poster;

  // 发布人地址
  final String posterHref;

  // 资源宽度
  final double width;

  // 资源高度
  final double height;

  // 来源
  final String source;

  // 等级
  final String rating;

  // 评分
  final double score;

  // 版权
  final List<TagModel> copyright;

  // 角色
  final List<TagModel> characters;

  // 艺术家
  final List<TagModel> artists;

  // 通用的
  final List<TagModel> general;

  // 元数据
  final List<TagModel> metadata;

  PostInfo({
    required this.postTime,
    required this.poster,
    required this.posterHref,
    required this.width,
    required this.height,
    required this.source,
    required this.rating,
    required this.score,
    required this.copyright,
    required this.characters,
    required this.artists,
    required this.general,
    required this.metadata,
  });

  @override
  PostInfo.from(obj)
    : postTime = DateTime.tryParse(obj?['postTime'] ?? '') ?? DateTime(1970),
      poster = obj?['poster'] ?? '',
      posterHref = obj?['posterHref'] ?? '',
      width = obj?['width'] ?? 0,
      height = obj?['height'] ?? 0,
      source = obj?['source'] ?? '',
      rating = obj?['rating'] ?? '',
      score = obj?['score'] ?? 0,
      metadata = (obj?['metadata'] as List?)?.map(TagModel.from).toList() ?? [],
      general = (obj?['general'] as List?)?.map(TagModel.from).toList() ?? [],
      artists = (obj?['artists'] as List?)?.map(TagModel.from).toList() ?? [],
      characters =
          (obj?['characters'] as List?)?.map(TagModel.from).toList() ?? [],
      copyright =
          (obj?['copyright'] as List?)?.map(TagModel.from).toList() ?? [];

  @override
  Map<String, dynamic> to() => {
    'postTime': postTime.toString(),
    'poster': poster,
    'posterHref': posterHref,
    'width': width,
    'height': height,
    'source': source,
    'rating': rating,
    'score': score,
    'metadata': metadata.map((e) => e.to()).toList(),
    'general': general.map((e) => e.to()).toList(),
    'artists': artists.map((e) => e.to()).toList(),
    'characters': characters.map((e) => e.to()).toList(),
    'copyright': copyright.map((e) => e.to()).toList(),
  };
}

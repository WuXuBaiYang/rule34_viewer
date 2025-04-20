import 'dart:math';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:jtech_base/common/api/request.dart';
import 'package:rule34_viewer/api/rule34_parser.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'api.dart';

/*
* Rule34接口
* @author wuxubaiyang
* @Time 2025/3/26 17:12
*/
mixin Rule34API on CustomAPI {
  // 获取帖子列表
  Future<List<PostModel>> loadPostList({
    List<String> tags = const [],
    int pageIndex = 1,
    int pageSize = 42,
  }) async {
    final bs = await _reqPage(
      'post',
      parameters: {
        's': 'list',
        'tags': tags.join('+'),
        'pid': max(0, pageIndex - 1) * pageSize,
      },
    );
    return Rule34WebParser.postList(bs);
  }

  // 获取帖子详情
  Future<PostModel> getPostInfo(String href) async {
    final parameters = Uri.parse(href).queryParameters;
    return Rule34WebParser.postInfo(
      href: href,
      await htmlGet(href),
      ids: await getPostNavigatorIds(
        parameters['id'] ?? '',
        parameters['tags']?.split('+') ?? [],
      ),
    );
  }

  // 获取帖子前后id元组
  Future<PostNavigatorIds> getPostNavigatorIds(
    String id,
    List<String> tags,
  ) async {
    final resp = await get(
      '/public/post_helpers2.php',
      request: RequestModel.query(
        parameters: {
          'action': 'fetch_id_cache',
          'tags': tags.isNotEmpty ? tags.join('+') : 'all',
          'id': id,
        },
      ),
    );
    return Rule34WebParser.postNavigatorIds(resp.data, id);
  }

  // 获取标签列表
  Future<List<TagModel>> loadTagList({
    required List<String> tags,
    int pageIndex = 1,
    int pageSize = 20,
    SortType sort = SortType.asc,
    TagSortType type = TagSortType.update,
  }) async {
    final bs = await _reqPage(
      'tags',
      parameters: {
        's': 'list',
        'sort': sort.name,
        'tags': tags.join('+'),
        'order_by': type.value,
        'pid': max(0, pageIndex - 1) * pageSize,
      },
    );
    return Rule34WebParser.tagList(bs);
  }

  // 请求rule34的页面接口
  Future<BeautifulSoup> _reqPage(
    String page, {
    Map<String, dynamic> parameters = const {},
  }) {
    final request = RequestModel.query(
      parameters: {'page': page, ...parameters},
    );
    return htmlGet('/index.php', request: request);
  }
}

import 'dart:math';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:jtech_base/common/api/request.dart';
import 'package:rule34_viewer/model/post.dart';
import 'api.dart';

/*
* Rule34接口
* @author wuxubaiyang
* @Time 2025/3/26 17:12
*/
mixin Rule34API on CustomAPI {
  // 获取帖子列表
  Future<List<PostModel>> loadPosts({
    List<String> tags = const [],
    int pageIndex = 1,
    int pageSize = 42,
  }) async {
    final parameters = {
      's': 'list',
      'pid': max(0, pageIndex - 1) * pageSize,
      'tags': (tags.isEmpty ? ['all'] : tags).join('+'),
    };
    final bs = await _reqPage('post', parameters: parameters);
    return (bs.find('div', class_: 'content')?.findAll('a') ?? <Bs4Element>[])
        .where((e) => e.id.startsWith('p'))
        .map<PostModel>((e) {
          final img = e.find('img');
          return PostModel.simple(
            id: e.id.substring(1),
            href: e.getAttrValue('href') ?? '',
            thumbUrl: img?.getAttrValue('src') ?? '',
            isVideo: img?.className == 'preview webm-thumb',
          );
        })
        .toList();
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

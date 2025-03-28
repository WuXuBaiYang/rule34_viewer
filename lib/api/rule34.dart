import 'dart:math';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:jtech_base/common/api/request.dart';
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
    final parameters = {
      's': 'list',
      'tags': tags.join('+'),
      'pid': max(0, pageIndex - 1) * pageSize,
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

  // 获取帖子详情
  Future<PostModel> getPostInfo(PostModel post) async {
    final parameters = {'s': 'view', 'id': post.id};
    final bs = await _reqPage('post', parameters: parameters);
    // 解析基本参数
    final stats = bs.find('div', id: 'stats')?.findAll('li');
    final sizes = (stats?.elementAt(2).text.replaceAll('Size:', '').trim() ??
            '')
        .split('x');
    String? source, rating, score;
    if (stats?.length == 5) {
      rating = stats?.elementAt(3).text.replaceAll('Rating:', '').trim();
      score = stats?.elementAt(4).find('span')?.text;
    } else if (stats?.length == 6) {
      source = stats?.elementAt(3).find('a')?.getAttrValue('href');
      rating = stats?.elementAt(4).text.replaceAll('Rating:', '').trim();
      score = stats?.elementAt(5).find('span')?.text;
    }
    List<TagModel>? getTags(String class_) {
      return bs.findAll('li', class_: class_).map<TagModel>((e) {
        final a = e.findAll('a').lastOrNull;
        final count = int.tryParse(
          e.find('span', class_: 'tag-count')?.text.trim() ?? '',
        );
        return TagModel(
          tag: a?.text.trim() ?? '',
          href: a?.getAttrValue('href') ?? '',
          count: count ?? 0,
        );
      }).toList();
    }

    final postedTime = stats
        ?.elementAt(1)
        .nodes
        .firstOrNull
        ?.text
        ?.replaceAll('Posted:', '');
    final postInfo = PostInfo(
      postTime: DateTime.tryParse(postedTime?.trim() ?? '') ?? DateTime(1970),
      poster: stats?.elementAt(1).find('a')?.text.trim() ?? '',
      posterHref: stats?.elementAt(1).find('a')?.getAttrValue('href') ?? '',
      width: double.tryParse(sizes.first) ?? 0,
      height: double.tryParse(sizes.last) ?? 0,
      source: source ?? '',
      rating: rating ?? '',
      score: double.tryParse(score ?? '') ?? 0.0,
      copyright: getTags('tag-type-copyright tag') ?? [],
      characters: getTags('tag-type-character tag') ?? [],
      artists: getTags('tag-type-artist tag') ?? [],
      general: getTags('tag-type-general tag') ?? [],
      metadata: getTags('tag-type-metadata tag') ?? [],
    );
    // 解析数据源信息
    String? sourceUrl;
    int? width, height;
    if (post.isVideo) {
      sourceUrl = bs
          .find('source', attrs: {'type': 'video/mp4'})
          ?.getAttrValue('src');
    } else {
      final i = bs.find('img', id: 'image');
      sourceUrl = i?.getAttrValue('src');
      width = int.tryParse(i?.getAttrValue('width') ?? '');
      height = int.tryParse(i?.getAttrValue('height') ?? '');
    }
    return post.copyWith(
      width: width,
      height: height,
      postInfo: postInfo,
      sourceUrl: sourceUrl,
    );
  }

  // 获取标签列表
  Future<List<TagModel>> loadTagList({
    required List<String> tags,
    int pageIndex = 1,
    int pageSize = 20,
    SortType sort = SortType.asc,
    TagSortType type = TagSortType.update,
  }) async {
    final parameters = {
      's': 'list',
      'sort': sort.name,
      'tags': tags.join('+'),
      'order_by': type.value,
      'pid': max(0, pageIndex - 1) * pageSize,
    };
    final bs = await _reqPage('tags', parameters: parameters);
    return (bs
                .find('table', class_: 'highlightable')
                ?.findAll('tr')
                .where((e) => !e.hasAttr('class')) ??
            <Bs4Element>[])
        .map<TagModel>((e) {
          final tds = e.findAll('td');
          final name = tds[1].find('a');
          return TagModel(
            tag: name?.text ?? '',
            href: name?.getAttrValue('href') ?? '',
            count: int.tryParse(tds[0].text) ?? 0,
            types:
                tds[2].nodes.firstOrNull?.text
                    ?.replaceAll('(', '')
                    .trim()
                    .split(',') ??
                [],
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

import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';

// 帖子路由ids元组
typedef PostNavigatorIds = ({String? prev, String? next});

/*
* Rule34网页解析器
* @author wuxubaiyang
* @Time 2025/4/20 23:13
*/
class Rule34WebParser {
  // 解析帖子列表
  static List<PostModel> postList(BeautifulSoup bs) {
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

  // 解析帖子详情
  static PostModel postInfo(
    BeautifulSoup bs, {
    required String href,
    PostNavigatorIds? ids,
  }) {
    // 解析基本参数
    final stats = bs.find('div', id: 'stats')?.findAll('li');
    final id = stats?.elementAt(0).text.replaceAll('Id:', '').trim() ?? '';
    final postedTime = stats
        ?.elementAt(1)
        .nodes
        .firstOrNull
        ?.text
        ?.replaceAll('Posted:', '');
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
    // 解析数据源信息
    final videoUrl = bs
        .find('source', attrs: {'type': 'video/mp4'})
        ?.getAttrValue('src');
    final imageUrl = bs.find('img', id: 'image')?.getAttrValue('src');
    final sourceUrl = videoUrl ?? imageUrl ?? '';
    final fileKey = sourceUrl.split('/').lastOrNull?.split('.').firstOrNull;
    final thumbUrl =
        'https://wimg.rule34.xxx/thumbnails/2916/thumbnail_$fileKey.jpg?$id';
    return PostModel(
      id: id,
      href: href,
      thumbUrl: thumbUrl,
      sourceUrl: sourceUrl,
      isVideo: videoUrl != null,
      prevHref: _getPrevNextHref(bs, 'prev_search_link', ids?.prev),
      nextHref: _getPrevNextHref(bs, 'next_search_link', ids?.next),
      postInfo: PostInfo(
        source: source ?? '',
        rating: rating ?? '',
        width: double.tryParse(sizes.first) ?? 0,
        height: double.tryParse(sizes.last) ?? 0,
        score: double.tryParse(score ?? '') ?? 0.0,
        poster: stats?.elementAt(1).find('a')?.text.trim() ?? '',
        postTime: DateTime.tryParse(postedTime?.trim() ?? '') ?? DateTime(1970),
        artists: _getPostTags(bs, 'tag-type-artist tag') ?? [],
        general: _getPostTags(bs, 'tag-type-general tag') ?? [],
        metadata: _getPostTags(bs, 'tag-type-metadata tag') ?? [],
        copyright: _getPostTags(bs, 'tag-type-copyright tag') ?? [],
        characters: _getPostTags(bs, 'tag-type-character tag') ?? [],
      ),
    );
  }

  // 解析当前帖子前后id元组
  static PostNavigatorIds postNavigatorIds(String json, String id) {
    final result = List<String>.from(jsonDecode(json).map((e) => '$e'));
    final index = result.indexOf(id);
    return (
      prev: index > 0 ? result.elementAt(index - 1) : null,
      next: result.elementAtOrNull(index + 1),
    );
  }

  // 解析标签集合
  static List<TagModel> tagList(BeautifulSoup bs) {
    final tables = bs.find('table', class_: 'highlightable')?.findAll('tr');
    return (tables?.where((e) => !e.hasAttr('class')) ?? <Bs4Element>[])
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

  // 解析帖子标签集合
  static List<TagModel>? _getPostTags(BeautifulSoup bs, String class_) {
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

  // 解析前后贴href
  static String? _getPrevNextHref(BeautifulSoup bs, String id, String? idP) {
    if (idP == null) return null;
    return bs
        .find('a', id: id)
        ?.getAttrValue('href')
        ?.replaceAll('IDPLACEHOLDER', idP);
  }
}

import 'package:extended_image/extended_image.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/database/model/collect.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'package:rule34_viewer/widget/appbar_desktop.dart';

/*
* 帖子详情(桌面端)
* @author wuxubaiyang
* @Time 2025/4/1 0:32
*/
class PostDesktopPage extends ProviderPage<PostDesktopProvider> {
  PostDesktopPage({super.key, super.state});

  @override
  PostDesktopProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => PostDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return createSelector<PostModel?>(
      selector: (_, p) => p.postInfo,
      builder: (_, postInfo, __) {
        final info = postInfo?.postInfo;
        return Scaffold(
          appBar: DesktopAppBar(
            title: Text(info != null ? '@${info.poster}' : ''),
          ),
          body: _buildPostInfo(postInfo),
        );
      },
    );
  }

  // 构建帖子详情
  Widget _buildPostInfo(PostModel? postInfo) {
    if (postInfo == null) return SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        if (postInfo.isVideo)
          Video(controller: provider.controller)
        else
          ExtendedImage.network(
            cache: true,
            postInfo.sourceUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
          ),
      ],
    );
  }
}

class PostDesktopProvider extends PageProvider {
  // 排序方式
  late final sort = find<SortType>('sort');

  // 播放器
  final player = Player();

  // 播放器控制器
  late final controller = VideoController(player);

  // 帖子详情
  PostModel? postInfo;

  // 收藏信息
  late CollectEntity? collectInfo = find<CollectEntity>('collectInfo');

  // 判断是否为收藏状态
  bool get isCollect => collectInfo != null;

  PostDesktopProvider(super.context, super.state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 加载帖子信息
      final href = find<PostModel>('postInfo')?.href ?? collectInfo?.href;
      if (href != null) _loadPostInfo(href).loading(context);
    });
  }

  // 路由帖子信息
  Future<void> navigatorPost(bool isNext) async {
    if (isCollect) return _navigatorCollect(isNext);
    final href = isNext ? postInfo?.nextHref : postInfo?.prevHref;
    if (href != null) _loadPostInfo(href);
  }

  // 路由收藏帖子信息
  Future<void> _navigatorCollect(bool isNext) async {
    if (collectInfo == null || sort == null) return;
    collectInfo = database.getCollectNavigator(
      collectInfo!,
      sort: sort!,
      isNext: isNext,
    );
    final href = collectInfo?.href;
    if (href != null) return _loadPostInfo(href);
  }

  // 加载帖子信息
  Future<void> _loadPostInfo(String href) async {
    final postInfo = await api.getPostInfo(href);
    _updatePostInfo(postInfo);
  }

  // 更新帖子信息
  Future<void> _updatePostInfo(PostModel postInfo) async {
    if (postInfo.isVideo) player.open(Media(postInfo.sourceUrl));
    this.postInfo = postInfo;
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

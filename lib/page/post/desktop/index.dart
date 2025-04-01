import 'package:extended_image/extended_image.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';

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
  // 排序类型
  late final SortType collectSortType =
      find<SortType>('collectSort') ?? SortType.desc;

  // 是否为收藏夹模式
  late final bool isCollect = findBool('isCollect') ?? false;

  // 标签集合
  late final List<String> tags = find<List<String>>('tags') ?? [];

  // 播放器
  final player = Player();

  // 播放器控制器
  late final controller = VideoController(player);

  // 帖子详情
  PostModel? postInfo;

  PostDesktopProvider(super.context, super.state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 初始加载帖子详情
      _loadPostInfo(find('id')).loading(context);
    });
  }

  // 跳转上一页/下一页
  Future<void> navigateToPost(bool isNext) async {
    String? postId;
    if (isCollect) {
      final collect = database.getCollectNavigatorById(
        postInfo?.postInfo?.postTime ?? DateTime.now(),
        isNext: isNext,
        sort: collectSortType,
      );
      postId = collect?.postId;
    } else {
      postId = isNext ? postInfo?.nextId : postInfo?.prevId;
    }
    _loadPostInfo(postId).loading(context);
  }

  // 加载帖子详情
  Future<void> _loadPostInfo(String? id) async {
    if (id == null) throw Exception('请传入帖子id');
    postInfo = await api.getPostInfo(id, tags);
    if (postInfo!.isVideo) player.open(Media(postInfo!.sourceUrl));
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

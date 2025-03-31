import 'package:extended_image/extended_image.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/model/post.dart';
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
  // 播放器
  final player = Player();

  // 播放器控制器
  late final controller = VideoController(player);

  // 帖子详情
  PostModel? postInfo;

  PostDesktopProvider(super.context, super.state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 初始加载帖子详情
      _loadPostInfo().loading(context);
    });
  }

  // 加载帖子详情
  Future<void> _loadPostInfo() async {
    final extra = getExtra<PostModel>();
    if (extra == null) throw Exception('请传入帖子详情');
    postInfo = await api.getPostInfo(extra);
    if (postInfo!.isVideo) player.open(Media(postInfo!.sourceUrl));
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

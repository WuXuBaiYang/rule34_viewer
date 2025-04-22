import 'package:extended_image/extended_image.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/common/common.dart';
import 'package:rule34_viewer/common/router.dart';
import 'package:rule34_viewer/database/database.dart';
import 'package:rule34_viewer/database/model/collect.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/model/tag.dart';
import 'package:rule34_viewer/tool/tool.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

// 弹窗的方式展示帖子详情
Future<void> showPostDesktopDialog(
  BuildContext context, {
  PostModel? postInfo,
  CollectEntity? collectInfo,
  SortType sort = SortType.desc,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return PostDesktopView(
        postInfo: postInfo,
        collectInfo: collectInfo,
        sort: sort,
      );
    },
  );
}

/*
* 帖子详情(桌面端)
* @author wuxubaiyang
* @Time 2025/4/1 0:32
*/
class PostDesktopView extends ProviderView<PostDesktopProvider> {
  final PostModel? postInfo;
  final CollectEntity? collectInfo;
  final SortType sort;

  PostDesktopView({
    super.key,
    this.postInfo,
    this.collectInfo,
    required this.sort,
  });

  @override
  PostDesktopProvider? createProvider(BuildContext context) =>
      PostDesktopProvider(
        context,
        postInfo: postInfo,
        collectInfo: collectInfo,
        sort: sort,
      );

  @override
  Widget buildWidget(BuildContext context) {
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
    );
    return GestureDetector(
      onTap: context.pop,
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Theme(
          data: Theme.of(context).copyWith(
            iconButtonTheme: IconButtonThemeData(style: buttonStyle),
            textButtonTheme: TextButtonThemeData(style: buttonStyle),
          ),
          child: Column(
            children: [
              DragToMoveArea(
                child: Container(
                  width: 60,
                  height: 6,
                  margin: EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(), // 直接使用StadiumBorder
                    color: Theme.of(context).primaryColor, // 背景色
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                  child: _buildPostInfo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建帖子详情
  Widget _buildPostInfo() {
    return createSelector3<PostModel?, bool, bool>(
      selector: (_, p) => (p.postInfo, p.hasPrev, p.hasNext),
      builder: (_, postInfo, hasPrev, hasNext, __) {
        return Row(
          spacing: 14,
          children: [
            AnimatedOpacity(
              opacity: hasPrev ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: () => provider.navigatorPost(false).loading(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                padding: EdgeInsets.symmetric(vertical: 45),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPostTitle(postInfo),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child:
                          postInfo?.isVideo == true
                              ? _buildPostVideo(postInfo)
                              : _buildPostImage(postInfo),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: hasNext ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: () => provider.navigatorPost(true).loading(context),
                icon: Icon(Icons.arrow_forward_ios_rounded),
                padding: EdgeInsets.symmetric(vertical: 45),
              ),
            ),
          ],
        );
      },
    );
  }

  // 构建标题信息
  Widget _buildPostTitle(PostModel? postInfo) {
    final poster = postInfo?.postInfo?.poster ?? '';
    final href = postInfo?.href ?? '';
    return Row(
      spacing: 14,
      children: [
        CloseButton(),
        TextButton(
          onPressed: provider.goToPoster,
          onLongPress: () => provider.copyToClipboard(poster),
          child: Text('@$poster'),
        ),
        TextButton(
          onPressed: provider.openWebView,
          onLongPress: () => provider.copyToClipboard('${Common.baseUrl}$href'),
          style: ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size(200, 40)),
          ),
          child: Text(href, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Spacer(),
        createSelector<bool>(
          selector: (_, p) => p.isCollect,
          builder: (_, isCollect, __) {
            final collectIcon =
                isCollect ? Icons.star_rate_rounded : Icons.star_border_rounded;
            return IconButton(
              isSelected: isCollect,
              icon: Icon(collectIcon),
              onPressed: provider.collectPost,
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.info_outline_rounded),
          onPressed: provider.showPostInfo,
        ),
      ],
    );
  }

  // 构建帖子图片信息
  Widget _buildPostImage(PostModel? postInfo) {
    if (postInfo == null) return const SizedBox();
    return ExtendedImage.network(
      cache: true,
      postInfo.sourceUrl,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
    );
  }

  // 构建帖子视频信息
  Widget _buildPostVideo(PostModel? postInfo) {
    if (postInfo == null) return const SizedBox();
    return Video(controller: provider.controller);
  }
}

class PostDesktopProvider extends BaseProvider {
  // 排序方式
  final SortType sort;

  // 播放器
  final player = Player();

  // 播放器控制器
  late final controller = VideoController(player);

  // 帖子详情
  PostModel? postInfo;

  // 收藏信息
  CollectEntity? collectInfo;

  // 记录当前是否为收藏状态
  bool isCollect = false;

  // 是否存在上一条数据
  bool hasPrev = false;

  // 是否存在下一条数据
  bool hasNext = false;

  PostDesktopProvider(
    super.context, {
    PostModel? postInfo,
    this.collectInfo,
    required this.sort,
  }) {
    _refreshCollectStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 加载帖子信息
      final href = postInfo?.href ?? collectInfo?.href;
      if (href != null) _loadPostInfo(href).loading(context);
    });
  }

  // 路由帖子信息
  Future<void> navigatorPost(bool isNext) async {
    await player.pause();
    if (collectInfo != null) return _navigatorCollect(isNext);
    final href = isNext ? postInfo?.nextHref : postInfo?.prevHref;
    if (href != null) return _loadPostInfo(href);
  }

  // 路由收藏帖子信息
  Future<void> _navigatorCollect(bool isNext) async {
    if (collectInfo == null) return;
    collectInfo =
        database.getCollectNavigator(
          collectInfo!,
          isNext: isNext,
          sort: sort,
        ) ??
        collectInfo;
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
    // 更新上下条数据状态
    if (collectInfo != null) {
      hasPrev = database.hasPrevCollect(collectInfo!, sort: sort);
      hasNext = database.hasNextCollect(collectInfo!, sort: sort);
    } else {
      hasPrev = postInfo.prevHref != null;
      hasNext = postInfo.nextHref != null;
    }
    notifyListeners();
  }

  // 收藏/取消收藏帖子
  Future<void> collectPost() async {
    if (postInfo == null) return;
    if (isCollect) {
      database.unCollectPost(postInfo!.id);
    } else {
      await database.collectPost(postInfo!);
    }
    _refreshCollectStatus();
  }

  // 跳转到帖子发起人搜索页
  void goToPoster() async {
    final poster = postInfo?.postInfo?.poster;
    if (poster == null) return;
    await router.goSearch(poster);
    _refreshCollectStatus();
  }

  // 显示帖子信息
  void showPostInfo() {
    if (postInfo == null) return;

    showNoticeInfo('功能开发中');

    /// 显示帖子信息
  }

  // 打开网页
  void openWebView() async {
    final uri = Uri.parse('${Common.baseUrl}${postInfo?.href}');
    if (!await launchUrl(uri)) showNoticeError('打开网页失败');
  }

  // 复制信息到剪切板
  void copyToClipboard(String text) {
    if (text.isEmpty) return;
    XTool.writeToClipboard(text);
    showNoticeSuccess('已复制到剪切板');
  }

  // 刷新收藏状态
  void _refreshCollectStatus() {
    if (postInfo == null) return;
    isCollect = database.isPostCollected(postInfo!.id);
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

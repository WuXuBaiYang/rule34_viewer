import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/home/post_grid.dart';
import 'package:rule34_viewer/page/home/tag_sheet.dart';
import 'package:rule34_viewer/page/home/tag_list.dart';
import 'package:rule34_viewer/provider/config.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
import 'package:rule34_viewer/widget/divider.dart';
import 'package:window_manager/window_manager.dart';

/*
* 首页(桌面端)
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomeDesktopPage extends ProviderPage<HomeDesktopPageProvider> {
  HomeDesktopPage({super.key, super.state});

  @override
  HomeDesktopPageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomeDesktopPageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(title: Text('Rule34Viewer')),
      body: Column(
        children: [
          _buildTags(context),
          Expanded(child: _buildPostGridList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          context.theme.changeThemeMode(
            context.theme.themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }

  // 构建标签集合
  Widget _buildTags(BuildContext context) {
    final dividerSize = Size(20, 20);
    return Selector<ConfigProvider, List<String>>(
      selector: (_, p) => p.tagList,
      builder: (_, tagList, __) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Selector<ConfigProvider, bool>(
                builder: (_, isVideoOnly, __) {
                  return ChoiceChip(
                    label: Text('仅视频'),
                    showCheckmark: false,
                    selected: isVideoOnly,
                    onSelected: provider.updateVideoOnly,
                    labelStyle: TextTheme.of(context).labelSmall,
                  );
                },
                selector: (_, p) => p.isVideoOnly,
              ),
              if (tagList.isNotEmpty) ...[
                CustomVerticalDivider(size: dividerSize),
                Expanded(child: TagList(tagList: tagList)),
                CustomVerticalDivider(size: dividerSize),
              ] else
                Spacer(),
              IconButton(
                onPressed: provider.updateTags,
                icon: Icon(Icons.filter_alt_outlined),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ],
          ),
        );
      },
    );
  }

  // 构建帖子列表
  Widget _buildPostGridList(BuildContext context) {
    return createSelector<int>(
      selector: (_, p) => p.columnCount,
      builder: (_, columnCount, __) {
        return PostGridList(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 180,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            crossAxisCount: columnCount,
          ),
          controller: provider.controller,
          onRefreshLoad: provider.loadPostList,
          padding: EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 14),
        );
      },
    );
  }
}

class HomeDesktopPageProvider extends PageProvider with WindowListener {
  // 帖子控制器
  final controller = CustomRefreshController<PostModel>.empty(pageSize: 42);

  // 默认列宽
  late final columnWidth = windowSize.width / columnCount;

  // 帖子列数
  int columnCount = 5;

  // 全局配置
  late final ConfigProvider _config = context.config;

  HomeDesktopPageProvider(super.context, super.state) {
    // 监听窗口变化
    windowManager.addListener(this);
  }

  // 加载帖子列表
  void loadPostList(bool loadMore) async {
    final result = await api.loadPostList(
      tags: [if (_config.isVideoOnly) 'video', ..._config.tagList],
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
    );
    controller.finish(result, loadMore);
  }

  // 更新标签
  void updateTags() async {
    final result = await showCustomTagSheet(context, tags: _config.tagList);
    if (result == null) return;
    _config.setTags(result);
    controller.startRefresh();
  }

  // 更新仅视频
  void updateVideoOnly(bool value) {
    _config.setVideoOnly(value);
    controller.startRefresh();
  }

  @override
  void onWindowResize() async {
    final windowSize = await windowManager.getSize();
    columnCount = windowSize.width ~/ columnWidth;
    notifyListeners();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/home/post_grid.dart';
import 'package:rule34_viewer/page/home/tag_list.dart';
import 'package:rule34_viewer/provider/config.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';
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
        onPressed: () {
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
    return Selector<ConfigProvider, List<String>>(
      selector: (_, provider) => provider.tagList,
      builder: (_, tagList, __) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(child: TagList(tagList: tagList)),
              SizedBox.fromSize(size: Size(8, 20), child: VerticalDivider()),
              SizedBox(width: 8),
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
      selector: (_, provider) => provider.columnCount,
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

  HomeDesktopPageProvider(super.context, super.state) {
    // 监听窗口变化
    windowManager.addListener(this);
  }

  // 加载帖子列表
  void loadPostList(bool loadMore) async {
    final result = await api.loadPostList(
      tags: [],
      pageIndex: controller.getPage(loadMore),
      pageSize: controller.pageSize,
    );
    controller.finish(result, loadMore);
  }

  // 更新标签
  void updateTags() {
    /// 更新标签
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

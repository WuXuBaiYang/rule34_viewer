import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:jtech_base/widget/refresh.dart';
import 'package:rule34_viewer/database/model/collect.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/tool/download.dart';
import 'package:rule34_viewer/widget/collect_post_grid.dart';
import 'package:window_manager/window_manager.dart';

/*
* 收藏帖子表格列表(桌面端)
* @author wuxubaiyang
* @Time 2025/3/31 23:57
*/
class DesktopCollectPostGridList extends StatefulWidget {
  // 刷新/加载
  final ValueChanged<bool>? onRefreshLoad;

  // 控制器
  final CustomRefreshController<CollectEntity> controller;

  // 收藏回调
  final ValueChanged<CollectEntity>? onCollect;

  // 帖子点击世间
  final ValueChanged<CollectEntity>? onTap;

  // 初始化列数
  final int initialColumnCount;

  const DesktopCollectPostGridList({
    super.key,
    required this.controller,
    this.onTap,
    this.onCollect,
    this.onRefreshLoad,
    this.initialColumnCount = 3,
  });

  @override
  State<DesktopCollectPostGridList> createState() =>
      _DesktopCollectPostGridListState();
}

class _DesktopCollectPostGridListState extends State<DesktopCollectPostGridList>
    with WindowListener {
  // 默认列宽
  late final columnWidth = windowSize.width / widget.initialColumnCount;

  // 帖子列数
  late int columnCount = widget.initialColumnCount;

  // 记录当前hover的index
  int? hoverIndex;

  @override
  void initState() {
    super.initState();
    // 监听窗口变化
    windowManager.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 140,
      crossAxisCount: columnCount,
    );
    return CollectPostGridList(
      onTap: widget.onTap,
      gridDelegate: gridDelegate,
      controller: widget.controller,
      onRefreshLoad: widget.onRefreshLoad,
      onCollect:
          widget.onCollect != null
              ? (v) => setState(() => widget.onCollect?.call(v))
              : null,
      itemBuilder: (_, item, child) {
        return ContextMenuRegion<int?>(
          contextMenu: ContextMenu(
            borderRadius: BorderRadius.circular(8),
            entries: [
              MenuItem(label: '查看', value: 0),
              MenuItem(label: '取消收藏', value: 1),
              MenuItem(label: item.isVideo ? '下载' : '另存为', value: 2),
            ],
          ),
          onItemSelected:
              (v) => switch (v) {
                0 => widget.onTap?.call(item),
                1 => widget.onCollect?.call(item),
                2 => Downloader.saveCollect(item),
                _ => null,
              },
          child: child,
        );
      },
    );
  }

  @override
  void onWindowResize() async {
    final windowSize = await windowManager.getSize();
    setState(() => columnCount = windowSize.width ~/ columnWidth);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}

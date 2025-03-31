import 'package:flutter/material.dart';
import 'package:jtech_base/widget/refresh.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/widget/post_grid.dart';
import 'package:window_manager/window_manager.dart';

/*
* 帖子表格列表(桌面端)
* @author wuxubaiyang
* @Time 2025/3/31 23:57
*/
class DesktopPostGridList extends StatefulWidget {
  // 刷新/加载
  final ValueChanged<bool>? onRefreshLoad;

  // 控制器
  final CustomRefreshController<PostModel> controller;

  // 已收藏id列表
  final List<String> collectPostIds;

  // 收藏回调
  final ValueChanged<PostModel>? onCollect;

  // 帖子点击世间
  final ValueChanged<PostModel>? onTap;

  // 初始化列数
  final int initialColumnCount;

  const DesktopPostGridList({
    super.key,
    required this.controller,
    this.onTap,
    this.onCollect,
    this.onRefreshLoad,
    this.initialColumnCount = 5,
    this.collectPostIds = const [],
  });

  @override
  State<DesktopPostGridList> createState() => _DesktopPostGridListState();
}

class _DesktopPostGridListState extends State<DesktopPostGridList>
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
      mainAxisExtent: 180,
      crossAxisCount: columnCount,
    );
    return PostGridList(
      onTap: widget.onTap,
      hoverIndex: hoverIndex,
      gridDelegate: gridDelegate,
      controller: widget.controller,
      onRefreshLoad: widget.onRefreshLoad,
      collectPostIds: widget.collectPostIds,
      onItemHover: (v) => setState(() => hoverIndex = v),
      onCollect:
          widget.onCollect != null
              ? (v) => setState(() => widget.onCollect?.call(v))
              : null,
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

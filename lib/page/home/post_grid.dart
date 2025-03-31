import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/tool/tool.dart';

/*
* 帖子表格列表
* @author wuxubaiyang
* @Time 2025/3/28 0:05
*/
class PostGridList extends StatelessWidget {
  // 表格代理
  final SliverGridDelegate gridDelegate;

  // 刷新/加载
  final ValueChanged<bool>? onRefreshLoad;

  // 间距
  final EdgeInsetsGeometry padding;

  // 控制器
  final CustomRefreshController<PostModel> controller;

  // 已收藏id列表
  final List<String> collectPostIds;

  // 收藏回调
  final ValueChanged<PostModel>? onCollect;

  // 帖子点击世间
  final ValueChanged<PostModel>? onTap;

  // 当前hover的状态
  final int? hoverIndex;

  // hover回调
  final ValueChanged<int?>? onHoverIndex;

  const PostGridList({
    super.key,
    required this.controller,
    required this.gridDelegate,
    required this.onRefreshLoad,
    this.onTap,
    this.onCollect,
    this.hoverIndex,
    this.onHoverIndex,
    this.collectPostIds = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshView(
      controller: controller,
      onRefreshLoad: onRefreshLoad,
      builder: (_, dataList) {
        return GridView.builder(
          padding: padding,
          itemCount: dataList.length,
          gridDelegate: gridDelegate,
          itemBuilder: (_, i) {
            return _buildGridItem(context, dataList[i], i);
          },
        );
      },
    );
  }

  // 构建帖子子项
  Widget _buildGridItem(BuildContext context, PostModel item, int index) {
    bool hover = kIsMobile ? true : hoverIndex == index;
    final borderColor =
        item.isVideo ? Theme.of(context).primaryColor : Colors.transparent;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onHover: (v) {
        if (kIsMobile) return;
        onHoverIndex?.call(v ? index : null);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(bottom: BorderSide(width: 5, color: borderColor)),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showImage) CustomImage.network(item.thumbUrl),
              Padding(
                padding: EdgeInsets.all(4),
                child: AnimatedOpacity(
                  opacity: hover ? 1 : 0,
                  duration: Duration(milliseconds: 100),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton.filledTonal(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        collectPostIds.contains(item.id)
                            ? Icons.star_rate_rounded
                            : Icons.star_border_rounded,
                      ),
                      onPressed: () => onCollect?.call(item),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => onTap?.call(item),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/post.dart';

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

  const PostGridList({
    super.key,
    required this.controller,
    required this.gridDelegate,
    required this.onRefreshLoad,
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
            return _buildGridItem(context, dataList[i]);
          },
        );
      },
    );
  }

  // 构建帖子子项
  Widget _buildGridItem(BuildContext context, PostModel item) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CustomImage.network(item.thumbUrl),
          if (item.isVideo)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

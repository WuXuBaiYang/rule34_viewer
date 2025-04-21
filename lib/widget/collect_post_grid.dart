import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/database/model/collect.dart';
import 'package:rule34_viewer/main.dart';

/*
* 收藏帖子表格列表
* @author wuxubaiyang
* @Time 2025/3/28 0:05
*/
class CollectPostGridList extends StatelessWidget {
  // 表格代理
  final SliverGridDelegate gridDelegate;

  // 刷新/加载
  final ValueChanged<bool>? onRefreshLoad;

  // 间距
  final EdgeInsetsGeometry padding;

  // 控制器
  final CustomRefreshController<CollectEntity> controller;

  // 收藏回调
  final ValueChanged<CollectEntity>? onCollect;

  // 帖子点击世间
  final ValueChanged<CollectEntity>? onTap;

  const CollectPostGridList({
    super.key,
    required this.controller,
    required this.gridDelegate,
    required this.onRefreshLoad,
    this.onTap,
    this.onCollect,
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
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            return _buildGridItem(context, dataList[i], i);
          },
        );
      },
    );
  }

  // 构建帖子子项
  Widget _buildGridItem(BuildContext context, CollectEntity item, int index) {
    final borderColor =
        item.isVideo ? Theme.of(context).primaryColor : Colors.transparent;
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border(bottom: BorderSide(width: 5, color: borderColor)),
    );
    return InkWell(
      onTap: () => onTap?.call(item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: decoration,
        margin: const EdgeInsets.all(8),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showImage)
                Expanded(
                  child: CustomImage.network(item.thumbUrl, fit: BoxFit.cover),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => onCollect?.call(item),
                    icon: Icon(Icons.star),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

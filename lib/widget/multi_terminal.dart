import 'package:flutter/material.dart';
import 'package:rule34_viewer/tool/tool.dart';

/*
* 多终端页面
* @author wuxubaiyang
* @Time 2025/3/27 18:23
*/
class MultiTerminal extends StatelessWidget {
  // 桌面端
  final Widget? desktop;

  // 移动端
  final Widget? mobile;

  // 默认子元素
  final Widget? child;

  const MultiTerminal({super.key, this.desktop, this.mobile, this.child});

  @override
  Widget build(BuildContext context) {
    if (kIsDesktop) return desktop ?? _buildChild();
    if (kIsMobile) return mobile ?? _buildChild();
    return _buildChild();
  }

  // 构建默认元素
  Widget _buildChild() => child ?? ErrorWidget(Exception('未设置默认子元素'));
}

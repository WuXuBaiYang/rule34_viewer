import 'package:flutter/material.dart';

/*
* 自定义垂直分割线
* @author wuxubaiyang
* @Time 2025/3/28 11:29
*/
class CustomVerticalDivider extends StatelessWidget {
  // 分割线尺寸
  final Size? size;

  // 宽度
  final double? width;

  // 粗细
  final double? thickness;

  // 缩进
  final double? indent;

  // 结束缩进
  final double? endIndent;

  // 颜色
  final Color? color;

  const CustomVerticalDivider({
    super.key,
    this.size,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: VerticalDivider(
        width: width,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color,
      ),
    );
  }
}

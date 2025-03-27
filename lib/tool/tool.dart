import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/*
* 自定义工具
* @author wuxubaiyang
* @Time 2025/3/27 18:17
*/
class XTool {
  // 设置窗口大小（动画）
  static Future<void> setWindowSizeWithAnime(
    Size target, {
    double step = 0.04,
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 20),
  }) async {
    double v = 0;
    final c = Completer();
    final current = await windowManager.getSize();
    final tween = SizeTween(begin: current, end: target);
    final timer = Timer.periodic(duration, (_) {
      if ((v += step) >= 1) return c.complete();
      final value = curve.transform(v);
      final size = tween.transform(value);
      if (size == null) return;
      windowManager.setSize(size);
    });
    return c.future..whenComplete(timer.cancel);
  }
}

// 判断是否为桌面端
bool get kIsDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

// 判断是否为移动端
bool get kIsMobile => Platform.isAndroid || Platform.isIOS;

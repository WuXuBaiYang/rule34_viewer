import 'dart:io';

/*
* 自定义工具
* @author wuxubaiyang
* @Time 2025/3/27 18:17
*/
class XTool {}

// 判断是否为桌面端
bool get kIsDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

// 判断是否为移动端
bool get kIsMobile => Platform.isAndroid || Platform.isIOS;

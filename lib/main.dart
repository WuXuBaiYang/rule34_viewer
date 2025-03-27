import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/provider/window.dart';
import 'package:rule34_viewer/tool/tool.dart';
import 'package:window_manager/window_manager.dart';
import 'common/common.dart';
import 'common/router.dart';
import 'database/database.dart';
import 'provider/config.dart';
import 'provider/theme.dart';

// 桌面端窗口尺寸
const Size windowSize = Size(800, 600);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化桌面平台
  if (kIsDesktop) {
    await windowManager.ensureInitialized();
    final windowOptions = WindowOptions(
      center: true,
      size: windowSize,
      skipTaskbar: false,
      minimumSize: windowSize,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Colors.transparent,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  // 初始化
  await localCache.initialize();
  await database.initialize(Common.databaseName);
  // 启动应用
  runApp(MyApp());
}

class MyApp extends ProviderView {
  MyApp({super.key});

  @override
  List<SingleChildWidget> loadProviders(BuildContext context) => [
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(context),
    ),
    ChangeNotifierProvider<ConfigProvider>(
      create: (context) => ConfigProvider(context),
    ),
  ];

  @override
  Widget buildWidget(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) {
        return MaterialApp.router(
          title: 'Rule34Viewer',
          theme: theme.themeData,
          themeMode: theme.themeMode,
          darkTheme: theme.darkThemeData,
          debugShowCheckedModeBanner: false,
          routerConfig: router.createRouter(),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}

// 扩展context
extension GlobeProviderExtension on BuildContext {
  // 获取主题provider
  ThemeProvider get theme => Provider.of<ThemeProvider>(this, listen: false);

  // 获取配置provider
  ConfigProvider get config => Provider.of<ConfigProvider>(this, listen: false);

  // 获取窗口provider
  WindowProvider get window => Provider.of<WindowProvider>(this, listen: false);
}

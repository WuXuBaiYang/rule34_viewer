import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/page/home/desktop/index.dart';
import 'package:rule34_viewer/page/home/mobile/index.dart';
import 'package:rule34_viewer/widget/multi_terminal.dart';

/*
* 路由管理
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class Router extends BaseRouter {
  static final Router _instance = Router._internal();

  factory Router() => _instance;

  Router._internal();

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: '/',
      builder:
          (_, state) => MultiTerminal(
            desktop: HomeDesktopPage(state: state),
            mobile: HomeMobilePage(state: state),
          ),
      routes: [],
    ),
  ];

  // 跳转首页
  void goHome() => go('/');
}

// 全局单例
final router = Router();

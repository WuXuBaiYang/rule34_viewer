import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/model/post.dart';
import 'package:rule34_viewer/page/collect/desktop/index.dart';
import 'package:rule34_viewer/page/collect/mobile/index.dart';
import 'package:rule34_viewer/page/home/desktop/index.dart';
import 'package:rule34_viewer/page/home/mobile/index.dart';
import 'package:rule34_viewer/page/search/desktop/index.dart';
import 'package:rule34_viewer/page/search/mobile/index.dart';
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
      routes: [
        GoRoute(
          path: '/search',
          builder:
              (_, state) => MultiTerminal(
                desktop: SearchDesktopPage(state: state),
                mobile: SearchMobilePage(state: state),
              ),
        ),
        GoRoute(
          path: '/post',
          builder:
              (_, state) => MultiTerminal(
                // desktop: SearchDesktopPage(state: state),
                // mobile: SearchMobilePage(state: state),
              ),
        ),
        GoRoute(
          path: '/collect',
          builder:
              (_, state) => MultiTerminal(
                desktop: CollectDesktopPage(state: state),
                mobile: CollectMobilePage(state: state),
              ),
        ),
      ],
    ),
  ];

  // 跳转首页
  void goHome() => go('/');

  // 跳转搜索
  Future<void> goSearch() => push('/search');

  // 跳转到帖子详情
  Future<void> goPost(PostModel post) => push('/post', extra: post);

  // 跳转到收藏
  Future<void> goCollect() => push('/collect');
}

// 全局单例
final router = Router();

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/api/api.dart';
import 'package:rule34_viewer/model/post.dart';

/*
* 首页
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePage extends ProviderPage<HomePageProvider> {
  HomePage({super.key, super.state});

  @override
  HomePageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomePageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('首页')),
      floatingActionButton: FloatingActionButton(onPressed: provider.test),
    );
  }
}

/*
* 首页状态管理
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePageProvider extends PageProvider {
  HomePageProvider(super.context, super.state);

  PostModel? post;

  void test() async {
    post ??= (await api.loadPostList())[2];
    final rs = await api.getPostInfo(post!);
    print('');
  }
}

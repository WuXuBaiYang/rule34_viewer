import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 帖子详情(桌面端)
* @author wuxubaiyang
* @Time 2025/4/1 0:32
*/
class PostDesktopPage extends ProviderPage<PostDesktopProvider> {
  PostDesktopPage({super.key, super.state});

  @override
  PostDesktopProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      PostDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帖子详情（桌面端）'),
      ),
      body: const SizedBox(),
    );
  }
}

class PostDesktopProvider extends PageProvider {
  PostDesktopProvider(super.context, super.state);
}

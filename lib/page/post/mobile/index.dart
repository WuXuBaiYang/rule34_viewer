import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 帖子详情(移动端)
* @author wuxubaiyang
* @Time 2025/4/1 0:32
*/
class PostMobilePage extends ProviderPage<PostMobileProvider> {
  PostMobilePage({super.key, super.state});

  @override
  PostMobileProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => PostMobileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('帖子详情(移动端)')),
      body: const SizedBox(),
    );
  }
}

class PostMobileProvider extends PageProvider {
  PostMobileProvider(super.context, super.state);
}

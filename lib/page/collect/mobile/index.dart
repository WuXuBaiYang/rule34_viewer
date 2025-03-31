import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 收藏页面(移动端)
* @author wuxubaiyang
* @Time 2025/3/31 17:32
*/
class CollectMobilePage extends ProviderPage<CollectMobileProvider> {
  CollectMobilePage({super.key, super.state});

  @override
  CollectMobileProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => CollectMobileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('收藏页面(移动端)')),
      body: const SizedBox(),
    );
  }
}

class CollectMobileProvider extends PageProvider {
  CollectMobileProvider(super.context, super.state);
}

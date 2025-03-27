import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页(移动端)
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomeMobilePage extends ProviderPage<HomeMobilePageProvider> {
  HomeMobilePage({super.key, super.state});

  @override
  HomeMobilePageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomeMobilePageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(body: Center(child: Text('首页')));
  }
}

class HomeMobilePageProvider extends PageProvider {
  HomeMobilePageProvider(super.context, super.state);
}

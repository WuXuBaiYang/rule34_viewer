import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 设置页(移动端)
* @author wuxubaiyang
* @Time 2025/4/1 0:37
*/
class SettingMobilePage extends ProviderPage<SettingMobileProvider> {
  SettingMobilePage({super.key, super.state});

  @override
  SettingMobileProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      SettingMobileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置页(移动端)'),
      ),
      body: const SizedBox(),
    );
  }
}

class SettingMobileProvider extends PageProvider {
  SettingMobileProvider(super.context, super.state);
}

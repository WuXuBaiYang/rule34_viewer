import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 设置页(桌面端)
* @author wuxubaiyang
* @Time 2025/4/1 0:37
*/
class SettingDesktopPage extends ProviderPage<SettingDesktopProvider> {
  SettingDesktopPage({super.key, super.state});

  @override
  SettingDesktopProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => SettingDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置页(桌面端)')),
      body: const SizedBox(),
    );
  }
}

class SettingDesktopProvider extends PageProvider {
  SettingDesktopProvider(super.context, super.state);
}

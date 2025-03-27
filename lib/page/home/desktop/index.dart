import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/main.dart';
import 'package:rule34_viewer/tool/tool.dart';
import 'package:rule34_viewer/widget/desktop_appbar.dart';

/*
* 首页(桌面端)
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomeDesktopPage extends ProviderPage<HomeDesktopPageProvider> {
  HomeDesktopPage({super.key, super.state});

  @override
  HomeDesktopPageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomeDesktopPageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    bool flag = true;
    return Scaffold(
      appBar: DesktopAppBar(title: Text('Rule34Viewer')),
      body: ListView.separated(
        itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
        separatorBuilder: (_, i) => Divider(),
        itemCount: 999,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          XTool.setWindowSizeWithAnime(
            (flag = !flag) ? windowSize : Size(1920, 1080),
          );
        },
      ),
    );
  }
}

class HomeDesktopPageProvider extends PageProvider {
  HomeDesktopPageProvider(super.context, super.state);
}

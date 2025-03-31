import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 下载(桌面端)
* @author wuxubaiyang
* @Time 2025/4/1 0:33
*/
class DownloadDesktopPage extends ProviderPage<DownloadDesktopProvider> {
  DownloadDesktopPage({super.key, super.state});

  @override
  DownloadDesktopProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      DownloadDesktopProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('下载(桌面端)'),
      ),
      body: const SizedBox(),
    );
  }
}

class DownloadDesktopProvider extends PageProvider {
  DownloadDesktopProvider(super.context, super.state);
}

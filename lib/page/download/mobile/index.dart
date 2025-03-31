import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 下载(移动端)
* @author wuxubaiyang
* @Time 2025/4/1 0:33
*/
class DownloadMobilePage extends ProviderPage<DownloadMobileProvider> {
  DownloadMobilePage({super.key, super.state});

  @override
  DownloadMobileProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      DownloadMobileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('下载(移动端)'),
      ),
      body: const SizedBox(),
    );
  }
}

class DownloadMobileProvider extends PageProvider {
  DownloadMobileProvider(super.context, super.state);
}

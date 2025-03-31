import 'package:jtech_base/jtech_base.dart';
import 'package:flutter/material.dart';

/*
* 搜索页面(移动端)
* @author wuxubaiyang
* @Time 2025/3/31 17:32
*/
class SearchMobilePage extends ProviderPage<SearchMobileProvider> {
  SearchMobilePage({super.key, super.state});

  @override
  SearchMobileProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => SearchMobileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜索页面(移动端)')),
      body: const SizedBox(),
    );
  }
}

class SearchMobileProvider extends PageProvider {
  SearchMobileProvider(super.context, super.state);
}

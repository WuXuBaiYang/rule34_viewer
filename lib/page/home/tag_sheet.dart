import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 自定义tag底部弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:32
*/
Future<List<String>?> showCustomTagSheet(
  BuildContext context, {
  required List<String> tags,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => CustomTagSheet(tags: tags),
  );
}

/*
* 自定义tag弹层
* @author wuxubaiyang
* @Time 2025/3/28 12:35
*/
class CustomTagSheet extends ProviderView<CustomTagSheetProvider> {
  // tag集合
  final List<String> tags;

  CustomTagSheet({super.key, required this.tags});

  @override
  CustomTagSheetProvider createProvider(BuildContext context) =>
      CustomTagSheetProvider(context, tags);

  @override
  Widget buildWidget(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) {
        return SizedBox();
      },
    );
  }
}

class CustomTagSheetProvider extends BaseProvider {
  // tag集合
  List<String> tags;

  CustomTagSheetProvider(super.context, this.tags);
}

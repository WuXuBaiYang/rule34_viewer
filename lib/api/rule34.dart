import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:jtech_base/common/api/request.dart';
import 'api.dart';

/*
* Rule34接口
* @author wuxubaiyang
* @Time 2025/3/26 17:12
*/
mixin Rule34API on CustomAPI {
  // 请求rule34的页面接口
  Future<BeautifulSoup> _reqPage(
    String page, {
    Map<String, dynamic> parameters = const {},
  }) {
    final request = RequestModel.query(
      parameters: {'page': page, ...parameters},
    );
    return htmlGet('/index.php', request: request);
  }
}

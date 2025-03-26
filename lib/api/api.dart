import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:rule34_viewer/common/common.dart';

/*
* 自定义API接口类
* @author wuxubaiyang
* @Time 2024/10/23 10:03
*/
class CustomAPI extends BaseAPI {
  CustomAPI({
    required super.baseUrl,
    super.interceptors,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
    super.maxRedirects,
    super.parameters,
    super.headers,
  });

  // 请求html网页源码
  Future<BeautifulSoup> htmlGet(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) async {
    final response = await get(
      path,
      request: request,
      cancelToken: cancelToken,
    );
    return BeautifulSoup(response.data);
  }
}

/*
* 接口入口
* @author wuxubaiyang
* @Time 2023/5/29 16:15
*/
class API extends CustomAPI {
  static final API _instance = API._internal();

  factory API() => _instance;

  API._internal()
    : super(baseUrl: Common.baseUrl, interceptors: [customInterceptor]);

  // 自定义拦截器
  static final customInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      return handler.next(options);
    },
    onResponse: (resp, handler) {
      return handler.next(resp);
    },
  );
}

// 全局单例入口
final api = API();

import 'package:jtech_base/jtech_base.dart';

/*
* 全局设置
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ConfigProvider extends BaseConfigProvider<AppConfig> {
  ConfigProvider(super.context) : super(creator: AppConfig.from);

  // 获取标签集合
  List<String> get tagList => config.tags;

  // 添加标签
  void addTag(String tag) =>
      updateConfig(config.copyWith(tags: [...config.tags, tag]));

  // 移除标签
  void removeTag(String tag) =>
      updateConfig(config.copyWith(tags: config.tags..remove(tag)));

  // 移除所有标签
  void removeAllTag() => updateConfig(config.copyWith(tags: []));

  // 获取搜索记录
  List<String> get searchHistory => config.searchHistory;

  // 添加搜索记录
  void addSearchHistory(String search) => updateConfig(
    config.copyWith(searchHistory: [...config.searchHistory, search]),
  );

  // 移除搜索记录
  void removeSearchHistory(String search) => updateConfig(
    config.copyWith(searchHistory: config.searchHistory..remove(search)),
  );

  // 移除所有搜索记录
  void removeAllSearchHistory() =>
      updateConfig(config.copyWith(searchHistory: []));
}

/*
* 配置文件对象
* @author wuxubaiyang
* @Time 2024/8/14 14:40
*/
class AppConfig extends BaseConfig {
  // 缓存过滤标签
  final List<String> tags;

  // 搜索记录
  final List<String> searchHistory;

  AppConfig({required this.tags, required this.searchHistory});

  AppConfig.from(obj)
    : tags = obj?['tags'] ?? [],
      searchHistory = obj?['searchHistory'] ?? [];

  @override
  Map<String, dynamic> to() => {'tags': tags, 'searchHistory': searchHistory};

  @override
  AppConfig copyWith({List<String>? tags, List<String>? searchHistory}) {
    return AppConfig(
      tags: tags ?? this.tags,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}

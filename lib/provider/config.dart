import 'package:jtech_base/jtech_base.dart';

/*
* 全局设置
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ConfigProvider extends BaseConfigProvider<AppConfig> {
  ConfigProvider(super.context) : super(creator: AppConfig.from);

  // 是否为仅视频模式
  bool get isVideoOnly => config.isVideoOnly;

  // 设置是否为仅视频模式
  void setVideoOnly(bool isVideoOnly) =>
      updateConfig(config.copyWith(isVideoOnly: isVideoOnly));

  // 获取标签集合
  List<String> get tagList => config.tags;

  // 替换全部标签
  void setTags(List<String> tags) => updateConfig(config.copyWith(tags: tags));

  // 添加标签
  void addTag(String tag) =>
      updateConfig(config.copyWith(tags: [...config.tags, tag]));

  // 添加多条标签
  void addTags(List<String> tags) =>
      updateConfig(config.copyWith(tags: [...config.tags, ...tags]));

  // 移除标签
  void removeTag(String tag) =>
      updateConfig(config.copyWith(tags: config.tags..remove(tag)));

  // 移除多个标签
  void removeTags(List<String> tags) => updateConfig(
    config.copyWith(tags: config.tags..removeWhere((e) => tags.contains(e))),
  );

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

  // 是否为仅视频模式
  final bool isVideoOnly;

  AppConfig({
    required this.tags,
    required this.searchHistory,
    required this.isVideoOnly,
  });

  AppConfig.from(obj)
    : tags = obj?['tags']?.map<String>((e) => e.toString()).toList(),
      isVideoOnly = obj?['isVideoOnly'] ?? false,
      searchHistory =
          obj?['searchHistory']?.map<String>((e) => e.toString()).toList();

  @override
  Map<String, dynamic> to() => {
    'tags': tags,
    'searchHistory': searchHistory,
    'isVideoOnly': isVideoOnly,
  };

  @override
  AppConfig copyWith({
    List<String>? tags,
    List<String>? searchHistory,
    bool? isVideoOnly,
  }) {
    return AppConfig(
      tags: tags ?? this.tags,
      isVideoOnly: isVideoOnly ?? this.isVideoOnly,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 主题提供者
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ThemeProvider extends BaseThemeProvider {
  ThemeProvider(super.context);

  @override
  ThemeData createTheme(ThemeData themeData, Brightness brightness) {
    return themeData.copyWith(
      chipTheme: ChipThemeData(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        constraints: BoxConstraints(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../ui/theme.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  _saveToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  bool _LoadFromBox() {
    return _box.read(_key) ?? false;
  }

  ThemeMode get modeTheme {
    return _LoadFromBox() ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    Get.changeThemeMode(_LoadFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveToBox(!_LoadFromBox());
  }
}

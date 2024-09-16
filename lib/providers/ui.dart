import 'package:flutter/material.dart';
import 'package:looks_like_it/utils/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui.g.dart';

@riverpod
class ImageViewMode extends _$ImageViewMode {
  @override
  bool build() {
    return false;
  }

  bool toggle() {
    state = !state;
    return state;
  }
}


@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    return themeModePref;
  }

  Future<bool> setTheme(ThemeMode themeMode) async {
    return setThemeModePref(themeMode);
  }
}

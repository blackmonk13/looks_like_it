import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late Isar isar;

const themeModePrefsKey = "themeMode";
const executablePathPrefsKey = "managerpath";
const recentPathsPrefsKey = "recentpaths";

ThemeMode get themeModePref {
  final themeModeInt = prefs.getInt(themeModePrefsKey);

  if (themeModeInt == null) {
    return ThemeMode.system;
  }

  return ThemeMode.values.elementAtOrNull(themeModeInt) ?? ThemeMode.system;
}

Future<bool> setThemeModePref(ThemeMode themeMode) async {
  return prefs.setInt(themeModePrefsKey, themeMode.index);
}

String? get getExecutablePath {
  final executablePath = prefs.getString(executablePathPrefsKey);
  return executablePath;
}

Future<bool> setExecutablePath(String? newPath) async {
  if (newPath == null) {
    return prefs.remove(executablePathPrefsKey);
  }

  if (newPath.isEmpty) {
    return false;
  }

  return prefs.setString(
    executablePathPrefsKey,
    newPath,
  );
}

List<String> get getRecentPaths {
  final recentPaths = prefs.getStringList(recentPathsPrefsKey);
  return recentPaths ?? [];
}

Future<bool> setRecentPaths(String? newPath) async {
  if (newPath == null) {
    return false;
  }

  if (newPath.isEmpty) {
    return false;
  }

  final existingPaths = getRecentPaths;

  if (existingPaths.contains(newPath)) {
    return true;
  }

  return prefs.setStringList(
    recentPathsPrefsKey,
    [
      ...existingPaths,
      newPath,
    ],
  );
}

Future<bool> deleteRecentPath(String pathToDelete) async {
  final existingPaths = getRecentPaths;

  // Check if the path exists in the list
  if (!existingPaths.contains(pathToDelete)) {
    return false;
  }

  // Remove the path from the list
  existingPaths.remove(pathToDelete);

  return prefs.setStringList(
    recentPathsPrefsKey,
    existingPaths,
  );
}

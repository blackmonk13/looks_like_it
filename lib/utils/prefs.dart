import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';

const themeModePrefsKey = "themeMode";
const executablePathPrefsKey = "managerpath";
const recentPathsPrefsKey = "recentpaths";

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}
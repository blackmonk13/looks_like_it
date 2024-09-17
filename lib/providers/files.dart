import 'package:file_picker/file_picker.dart';
import 'package:looks_like_it/utils/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files.g.dart';

@Riverpod(keepAlive: true)
class SimilaritiesExecutable extends _$SimilaritiesExecutable {
  @override
  String? build() {
    final sharedPrefs = ref.watch(sharedPreferencesProvider).requireValue;
    return sharedPrefs.getString(executablePathPrefsKey);
  }

  Future<void> pickExecutable() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      // User canceled the picker
      return;
    }

    final xFile = result.files.first.xFile;
    final success = await setExecutablePath(xFile.path);

    if (success) {
      state = xFile.path;
    }
  }

  Future<bool> setExecutablePath(String? newPath) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;
    if (newPath == null) {
      return sharedPrefs.remove(executablePathPrefsKey);
    }

    if (newPath.isEmpty) {
      return false;
    }

    return sharedPrefs.setString(
      executablePathPrefsKey,
      newPath,
    );
  }
}

@Riverpod(keepAlive: true)
class DirectoryPicker extends _$DirectoryPicker {
  @override
  String? build() {
    return null;
  }

  Future<String?> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
      return null;
    }

    state = selectedDirectory;

    return state;
  }

  String? setFolder(String folderPath) {
    state = folderPath;
    return state;
  }
}

@riverpod
class RecentPaths extends _$RecentPaths {
  @override
  FutureOr<List<String>> build() {
    final sharedPrefs = ref.watch(sharedPreferencesProvider).requireValue;
    final recentPaths = sharedPrefs.getStringList(recentPathsPrefsKey);
    return recentPaths ?? [];
  }

  Future<bool> add(String value) async {
    state = const AsyncLoading();
    final status = await setRecentPaths(value);
    await future;
    return status;
  }

  Future<bool> deleteRecentPath(String pathToDelete) async {
    final existingPaths = await future;

    // Check if the path exists in the list
    if (!existingPaths.contains(pathToDelete)) {
      return false;
    }

    // Remove the path from the list
    existingPaths.remove(pathToDelete);

    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;

    return sharedPrefs.setStringList(
      recentPathsPrefsKey,
      existingPaths,
    );
  }

  Future<bool> setRecentPaths(String? newPath) async {
    if (newPath == null) {
      return false;
    }

    if (newPath.isEmpty) {
      return false;
    }

    final existingPaths = await future;

    if (existingPaths.contains(newPath)) {
      return true;
    }

    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;

    return sharedPrefs.setStringList(
      recentPathsPrefsKey,
      [
        ...existingPaths,
        newPath,
      ],
    );
  }
}

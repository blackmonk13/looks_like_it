import 'package:file_picker/file_picker.dart';
import 'package:looks_like_it/utils/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files.g.dart';

@Riverpod(keepAlive: true)
class SimilaritiesExecutable extends _$SimilaritiesExecutable {
  @override
  String? build() {
    return getExecutablePath;
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
    return getRecentPaths;
  }

  Future<void> add(String value) async {
    state = const AsyncLoading();
    await setRecentPaths(value);

    state = AsyncValue.data(getRecentPaths);

    await future;
  }
}

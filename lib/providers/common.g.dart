// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileImageHash() => r'b7c7a1de23b39958f1b26df160552888d5f8d933';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fileImage].
@ProviderFor(fileImage)
const fileImageProvider = FileImageFamily();

/// See also [fileImage].
class FileImageFamily extends Family<FileImage> {
  /// See also [fileImage].
  const FileImageFamily();

  /// See also [fileImage].
  FileImageProvider call(
    String imagePath,
  ) {
    return FileImageProvider(
      imagePath,
    );
  }

  @override
  FileImageProvider getProviderOverride(
    covariant FileImageProvider provider,
  ) {
    return call(
      provider.imagePath,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fileImageProvider';
}

/// See also [fileImage].
class FileImageProvider extends AutoDisposeProvider<FileImage> {
  /// See also [fileImage].
  FileImageProvider(
    String imagePath,
  ) : this._internal(
          (ref) => fileImage(
            ref as FileImageRef,
            imagePath,
          ),
          from: fileImageProvider,
          name: r'fileImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fileImageHash,
          dependencies: FileImageFamily._dependencies,
          allTransitiveDependencies: FileImageFamily._allTransitiveDependencies,
          imagePath: imagePath,
        );

  FileImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imagePath,
  }) : super.internal();

  final String imagePath;

  @override
  Override overrideWith(
    FileImage Function(FileImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FileImageProvider._internal(
        (ref) => create(ref as FileImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imagePath: imagePath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FileImage> createElement() {
    return _FileImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FileImageProvider && other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imagePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FileImageRef on AutoDisposeProviderRef<FileImage> {
  /// The parameter `imagePath` of this provider.
  String get imagePath;
}

class _FileImageProviderElement extends AutoDisposeProviderElement<FileImage>
    with FileImageRef {
  _FileImageProviderElement(super.provider);

  @override
  String get imagePath => (origin as FileImageProvider).imagePath;
}

String _$isarHash() => r'ed1ace58ccfb023a9c707d1f5d8cd28a4204a91e';

/// See also [isar].
@ProviderFor(isar)
final isarProvider = FutureProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = FutureProviderRef<Isar>;
String _$appStartupHash() => r'5b0c55d95bd5828b52d230f7e4d11fe233abb9e4';

/// See also [appStartup].
@ProviderFor(appStartup)
final appStartupProvider = FutureProvider<void>.internal(
  appStartup,
  name: r'appStartupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStartupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppStartupRef = FutureProviderRef<void>;
String _$listFoldersHash() => r'dc89b5882864f27092c618e21dcfa7cba5763b06';

/// See also [listFolders].
@ProviderFor(listFolders)
const listFoldersProvider = ListFoldersFamily();

/// See also [listFolders].
class ListFoldersFamily extends Family<AsyncValue<List<String>>> {
  /// See also [listFolders].
  const ListFoldersFamily();

  /// See also [listFolders].
  ListFoldersProvider call(
    String folderPath,
  ) {
    return ListFoldersProvider(
      folderPath,
    );
  }

  @override
  ListFoldersProvider getProviderOverride(
    covariant ListFoldersProvider provider,
  ) {
    return call(
      provider.folderPath,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'listFoldersProvider';
}

/// See also [listFolders].
class ListFoldersProvider extends AutoDisposeStreamProvider<List<String>> {
  /// See also [listFolders].
  ListFoldersProvider(
    String folderPath,
  ) : this._internal(
          (ref) => listFolders(
            ref as ListFoldersRef,
            folderPath,
          ),
          from: listFoldersProvider,
          name: r'listFoldersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listFoldersHash,
          dependencies: ListFoldersFamily._dependencies,
          allTransitiveDependencies:
              ListFoldersFamily._allTransitiveDependencies,
          folderPath: folderPath,
        );

  ListFoldersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderPath,
  }) : super.internal();

  final String folderPath;

  @override
  Override overrideWith(
    Stream<List<String>> Function(ListFoldersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ListFoldersProvider._internal(
        (ref) => create(ref as ListFoldersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderPath: folderPath,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<String>> createElement() {
    return _ListFoldersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListFoldersProvider && other.folderPath == folderPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListFoldersRef on AutoDisposeStreamProviderRef<List<String>> {
  /// The parameter `folderPath` of this provider.
  String get folderPath;
}

class _ListFoldersProviderElement
    extends AutoDisposeStreamProviderElement<List<String>> with ListFoldersRef {
  _ListFoldersProviderElement(super.provider);

  @override
  String get folderPath => (origin as ListFoldersProvider).folderPath;
}

String _$selectedImageControllerHash() =>
    r'cf3f3a296bd8c8bf46890371f82d0996a204899f';

/// See also [SelectedImageController].
@ProviderFor(SelectedImageController)
final selectedImageControllerProvider =
    AutoDisposeNotifierProvider<SelectedImageController, int>.internal(
  SelectedImageController.new,
  name: r'selectedImageControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedImageControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedImageController = AutoDisposeNotifier<int>;
String _$selectedIdHash() => r'848c8e191426b9525ecf97147fccb676e3e48497';

/// See also [SelectedId].
@ProviderFor(SelectedId)
final selectedIdProvider =
    AutoDisposeNotifierProvider<SelectedId, int>.internal(
  SelectedId.new,
  name: r'selectedIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedId = AutoDisposeNotifier<int>;
String _$selectedSimilarityHash() =>
    r'9377235eb42f8642159e656711ce34dd3c5acede';

/// See also [SelectedSimilarity].
@ProviderFor(SelectedSimilarity)
final selectedSimilarityProvider =
    AutoDisposeNotifierProvider<SelectedSimilarity, int>.internal(
  SelectedSimilarity.new,
  name: r'selectedSimilarityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSimilarityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSimilarity = AutoDisposeNotifier<int>;
String _$scrollPositionHash() => r'99efa913e59be8488e40567fea7b4da9e301c39d';

abstract class _$ScrollPosition extends BuildlessNotifier<double> {
  late final String key;

  double build(
    String key,
  );
}

/// See also [ScrollPosition].
@ProviderFor(ScrollPosition)
const scrollPositionProvider = ScrollPositionFamily();

/// See also [ScrollPosition].
class ScrollPositionFamily extends Family<double> {
  /// See also [ScrollPosition].
  const ScrollPositionFamily();

  /// See also [ScrollPosition].
  ScrollPositionProvider call(
    String key,
  ) {
    return ScrollPositionProvider(
      key,
    );
  }

  @override
  ScrollPositionProvider getProviderOverride(
    covariant ScrollPositionProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scrollPositionProvider';
}

/// See also [ScrollPosition].
class ScrollPositionProvider
    extends NotifierProviderImpl<ScrollPosition, double> {
  /// See also [ScrollPosition].
  ScrollPositionProvider(
    String key,
  ) : this._internal(
          () => ScrollPosition()..key = key,
          from: scrollPositionProvider,
          name: r'scrollPositionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scrollPositionHash,
          dependencies: ScrollPositionFamily._dependencies,
          allTransitiveDependencies:
              ScrollPositionFamily._allTransitiveDependencies,
          key: key,
        );

  ScrollPositionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  double runNotifierBuild(
    covariant ScrollPosition notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(ScrollPosition Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScrollPositionProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  NotifierProviderElement<ScrollPosition, double> createElement() {
    return _ScrollPositionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScrollPositionProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScrollPositionRef on NotifierProviderRef<double> {
  /// The parameter `key` of this provider.
  String get key;
}

class _ScrollPositionProviderElement
    extends NotifierProviderElement<ScrollPosition, double>
    with ScrollPositionRef {
  _ScrollPositionProviderElement(super.provider);

  @override
  String get key => (origin as ScrollPositionProvider).key;
}

String _$selectedIndexHash() => r'16124a01df53664e40114b0e092ab5f9a219eb95';

/// See also [SelectedIndex].
@ProviderFor(SelectedIndex)
final selectedIndexProvider = NotifierProvider<SelectedIndex, int>.internal(
  SelectedIndex.new,
  name: r'selectedIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedIndex = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

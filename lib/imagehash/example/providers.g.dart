// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'2f7146697b8526ed8bc34456359f37d90cf8fdfe';

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
String _$appStartupHash() => r'4df61a08b2afc4d8cfa280758a9003e4d3727675';

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

String _$similarityThresholdHash() =>
    r'83ccb4792b207a7783018538fc24246d230da49a';

/// See also [SimilarityThreshold].
@ProviderFor(SimilarityThreshold)
final similarityThresholdProvider =
    NotifierProvider<SimilarityThreshold, double>.internal(
  SimilarityThreshold.new,
  name: r'similarityThresholdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similarityThresholdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SimilarityThreshold = Notifier<double>;
String _$similaritiesListHash() => r'0f7573236a79d9cffa46ba3dc1a62612fce5f59d';

/// See also [SimilaritiesList].
@ProviderFor(SimilaritiesList)
final similaritiesListProvider = AutoDisposeAsyncNotifierProvider<
    SimilaritiesList, List<ImageSimilarity>>.internal(
  SimilaritiesList.new,
  name: r'similaritiesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SimilaritiesList = AutoDisposeAsyncNotifier<List<ImageSimilarity>>;
String _$pathFiltersHash() => r'46d019180cabde850bde26fd7be67d11cd8abaed';

/// See also [PathFilters].
@ProviderFor(PathFilters)
final pathFiltersProvider =
    AutoDisposeNotifierProvider<PathFilters, List<String>>.internal(
  PathFilters.new,
  name: r'pathFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pathFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PathFilters = AutoDisposeNotifier<List<String>>;
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

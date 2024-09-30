// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findSimilaritiesHash() => r'47ed60fc56e49b57a6f0140ce0ab931ed28879c4';

/// See also [findSimilarities].
@ProviderFor(findSimilarities)
final findSimilaritiesProvider =
    AutoDisposeStreamProvider<List<ImageSimilarity>>.internal(
  findSimilarities,
  name: r'findSimilaritiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$findSimilaritiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FindSimilaritiesRef
    = AutoDisposeStreamProviderRef<List<ImageSimilarity>>;
String _$appStartupHash() => r'956de93366224fcc5612e5751416603ccca2e361';

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
String _$imageMetadataHash() => r'bc0ddc9cd3ac06b4c8399ce574a217663a6427ef';

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

/// See also [imageMetadata].
@ProviderFor(imageMetadata)
const imageMetadataProvider = ImageMetadataFamily();

/// See also [imageMetadata].
class ImageMetadataFamily extends Family<AsyncValue<ImageMetadata>> {
  /// See also [imageMetadata].
  const ImageMetadataFamily();

  /// See also [imageMetadata].
  ImageMetadataProvider call(
    String filePath,
  ) {
    return ImageMetadataProvider(
      filePath,
    );
  }

  @override
  ImageMetadataProvider getProviderOverride(
    covariant ImageMetadataProvider provider,
  ) {
    return call(
      provider.filePath,
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
  String? get name => r'imageMetadataProvider';
}

/// See also [imageMetadata].
class ImageMetadataProvider extends AutoDisposeFutureProvider<ImageMetadata> {
  /// See also [imageMetadata].
  ImageMetadataProvider(
    String filePath,
  ) : this._internal(
          (ref) => imageMetadata(
            ref as ImageMetadataRef,
            filePath,
          ),
          from: imageMetadataProvider,
          name: r'imageMetadataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$imageMetadataHash,
          dependencies: ImageMetadataFamily._dependencies,
          allTransitiveDependencies:
              ImageMetadataFamily._allTransitiveDependencies,
          filePath: filePath,
        );

  ImageMetadataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filePath,
  }) : super.internal();

  final String filePath;

  @override
  Override overrideWith(
    FutureOr<ImageMetadata> Function(ImageMetadataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImageMetadataProvider._internal(
        (ref) => create(ref as ImageMetadataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filePath: filePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ImageMetadata> createElement() {
    return _ImageMetadataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageMetadataProvider && other.filePath == filePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ImageMetadataRef on AutoDisposeFutureProviderRef<ImageMetadata> {
  /// The parameter `filePath` of this provider.
  String get filePath;
}

class _ImageMetadataProviderElement
    extends AutoDisposeFutureProviderElement<ImageMetadata>
    with ImageMetadataRef {
  _ImageMetadataProviderElement(super.provider);

  @override
  String get filePath => (origin as ImageMetadataProvider).filePath;
}

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

String _$lSHHash() => r'7b99405dfb892839140df5af6835fea969ed8080';

/// See also [LSH].
@ProviderFor(LSH)
final lSHProvider = AsyncNotifierProvider<LSH, PersistentLSH>.internal(
  LSH.new,
  name: r'lSHProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lSHHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LSH = AsyncNotifier<PersistentLSH>;
String _$imageProcessorHash() => r'd474d0df7496a3f72baf2ec756b3a6d0faf8bff9';

/// See also [ImageProcessor].
@ProviderFor(ImageProcessor)
final imageProcessorProvider =
    AsyncNotifierProvider<ImageProcessor, StreamingImageProcessor>.internal(
  ImageProcessor.new,
  name: r'imageProcessorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imageProcessorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ImageProcessor = AsyncNotifier<StreamingImageProcessor>;
String _$similarityThresholdHash() =>
    r'a22c194ded6eaeef3a5ed1a3fb66fe606b37bfbd';

/// See also [SimilarityThreshold].
@ProviderFor(SimilarityThreshold)
final similarityThresholdProvider =
    AutoDisposeNotifierProvider<SimilarityThreshold, double>.internal(
  SimilarityThreshold.new,
  name: r'similarityThresholdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similarityThresholdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SimilarityThreshold = AutoDisposeNotifier<double>;
String _$similaritiesListHash() => r'cd4207f065257b5334bc10d21b378496e14c95d6';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

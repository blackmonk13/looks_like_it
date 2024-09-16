// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similarities_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$similaritiesRepositoryHash() =>
    r'13ecd748b4cd244ce317c31dc01c50a12422773c';

/// See also [similaritiesRepository].
@ProviderFor(similaritiesRepository)
final similaritiesRepositoryProvider =
    AutoDisposeProvider<SimilaritiesRepository>.internal(
  similaritiesRepository,
  name: r'similaritiesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimilaritiesRepositoryRef
    = AutoDisposeProviderRef<SimilaritiesRepository>;
String _$findSimilaritiesHash() => r'd3c0011351598b6c8b9701609af08e95d701c808';

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

/// See also [findSimilarities].
@ProviderFor(findSimilarities)
const findSimilaritiesProvider = FindSimilaritiesFamily();

/// See also [findSimilarities].
class FindSimilaritiesFamily extends Family<AsyncValue<void>> {
  /// See also [findSimilarities].
  const FindSimilaritiesFamily();

  /// See also [findSimilarities].
  FindSimilaritiesProvider call({
    int threshold = 1,
    bool recursive = true,
  }) {
    return FindSimilaritiesProvider(
      threshold: threshold,
      recursive: recursive,
    );
  }

  @override
  FindSimilaritiesProvider getProviderOverride(
    covariant FindSimilaritiesProvider provider,
  ) {
    return call(
      threshold: provider.threshold,
      recursive: provider.recursive,
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
  String? get name => r'findSimilaritiesProvider';
}

/// See also [findSimilarities].
class FindSimilaritiesProvider extends AutoDisposeFutureProvider<void> {
  /// See also [findSimilarities].
  FindSimilaritiesProvider({
    int threshold = 1,
    bool recursive = true,
  }) : this._internal(
          (ref) => findSimilarities(
            ref as FindSimilaritiesRef,
            threshold: threshold,
            recursive: recursive,
          ),
          from: findSimilaritiesProvider,
          name: r'findSimilaritiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findSimilaritiesHash,
          dependencies: FindSimilaritiesFamily._dependencies,
          allTransitiveDependencies:
              FindSimilaritiesFamily._allTransitiveDependencies,
          threshold: threshold,
          recursive: recursive,
        );

  FindSimilaritiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threshold,
    required this.recursive,
  }) : super.internal();

  final int threshold;
  final bool recursive;

  @override
  Override overrideWith(
    FutureOr<void> Function(FindSimilaritiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindSimilaritiesProvider._internal(
        (ref) => create(ref as FindSimilaritiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threshold: threshold,
        recursive: recursive,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _FindSimilaritiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindSimilaritiesProvider &&
        other.threshold == threshold &&
        other.recursive == recursive;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threshold.hashCode);
    hash = _SystemHash.combine(hash, recursive.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindSimilaritiesRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `threshold` of this provider.
  int get threshold;

  /// The parameter `recursive` of this provider.
  bool get recursive;
}

class _FindSimilaritiesProviderElement
    extends AutoDisposeFutureProviderElement<void> with FindSimilaritiesRef {
  _FindSimilaritiesProviderElement(super.provider);

  @override
  int get threshold => (origin as FindSimilaritiesProvider).threshold;
  @override
  bool get recursive => (origin as FindSimilaritiesProvider).recursive;
}

String _$pagedSimilaritiesHash() => r'fdad4336b02cf58967b4e20f68edc5444f5f0514';

/// See also [pagedSimilarities].
@ProviderFor(pagedSimilarities)
const pagedSimilaritiesProvider = PagedSimilaritiesFamily();

/// See also [pagedSimilarities].
class PagedSimilaritiesFamily extends Family<AsyncValue<List<SimilarImage>>> {
  /// See also [pagedSimilarities].
  const PagedSimilaritiesFamily();

  /// See also [pagedSimilarities].
  PagedSimilaritiesProvider call(
    int page,
  ) {
    return PagedSimilaritiesProvider(
      page,
    );
  }

  @override
  PagedSimilaritiesProvider getProviderOverride(
    covariant PagedSimilaritiesProvider provider,
  ) {
    return call(
      provider.page,
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
  String? get name => r'pagedSimilaritiesProvider';
}

/// See also [pagedSimilarities].
class PagedSimilaritiesProvider
    extends AutoDisposeFutureProvider<List<SimilarImage>> {
  /// See also [pagedSimilarities].
  PagedSimilaritiesProvider(
    int page,
  ) : this._internal(
          (ref) => pagedSimilarities(
            ref as PagedSimilaritiesRef,
            page,
          ),
          from: pagedSimilaritiesProvider,
          name: r'pagedSimilaritiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pagedSimilaritiesHash,
          dependencies: PagedSimilaritiesFamily._dependencies,
          allTransitiveDependencies:
              PagedSimilaritiesFamily._allTransitiveDependencies,
          page: page,
        );

  PagedSimilaritiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<List<SimilarImage>> Function(PagedSimilaritiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PagedSimilaritiesProvider._internal(
        (ref) => create(ref as PagedSimilaritiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SimilarImage>> createElement() {
    return _PagedSimilaritiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PagedSimilaritiesProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PagedSimilaritiesRef on AutoDisposeFutureProviderRef<List<SimilarImage>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _PagedSimilaritiesProviderElement
    extends AutoDisposeFutureProviderElement<List<SimilarImage>>
    with PagedSimilaritiesRef {
  _PagedSimilaritiesProviderElement(super.provider);

  @override
  int get page => (origin as PagedSimilaritiesProvider).page;
}

String _$similaritiesHash() => r'e19d4bcc4ff56a590930b1a7c0d00ef6b58f4400';

/// See also [similarities].
@ProviderFor(similarities)
final similaritiesProvider =
    AutoDisposeFutureProvider<List<SimilarImage>>.internal(
  similarities,
  name: r'similaritiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$similaritiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimilaritiesRef = AutoDisposeFutureProviderRef<List<SimilarImage>>;
String _$imagesCountHash() => r'523d34d247432f1914e3bd987079fbb8912bf63a';

/// See also [imagesCount].
@ProviderFor(imagesCount)
final imagesCountProvider = AutoDisposeFutureProvider<int>.internal(
  imagesCount,
  name: r'imagesCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$imagesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImagesCountRef = AutoDisposeFutureProviderRef<int>;
String _$selectedImageHash() => r'05c20040324ff00e6f0506acc62eced2a562fd51';

/// See also [selectedImage].
@ProviderFor(selectedImage)
final selectedImageProvider = AutoDisposeFutureProvider<SimilarImage?>.internal(
  selectedImage,
  name: r'selectedImageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedImageRef = AutoDisposeFutureProviderRef<SimilarImage?>;
String _$similarImagesWatcherHash() =>
    r'b68de28d8e5d701812b92d68e22eafc48478ffab';

/// See also [similarImagesWatcher].
@ProviderFor(similarImagesWatcher)
final similarImagesWatcherProvider = AutoDisposeStreamProvider<void>.internal(
  similarImagesWatcher,
  name: r'similarImagesWatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similarImagesWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimilarImagesWatcherRef = AutoDisposeStreamProviderRef<void>;
String _$deleteImageHash() => r'031bde01bfa8412e23c69524f6e4c9a483e900f9';

abstract class _$DeleteImage extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final SimilarImage image;

  FutureOr<bool> build(
    SimilarImage image,
  );
}

/// See also [DeleteImage].
@ProviderFor(DeleteImage)
const deleteImageProvider = DeleteImageFamily();

/// See also [DeleteImage].
class DeleteImageFamily extends Family<AsyncValue<bool>> {
  /// See also [DeleteImage].
  const DeleteImageFamily();

  /// See also [DeleteImage].
  DeleteImageProvider call(
    SimilarImage image,
  ) {
    return DeleteImageProvider(
      image,
    );
  }

  @override
  DeleteImageProvider getProviderOverride(
    covariant DeleteImageProvider provider,
  ) {
    return call(
      provider.image,
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
  String? get name => r'deleteImageProvider';
}

/// See also [DeleteImage].
class DeleteImageProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DeleteImage, bool> {
  /// See also [DeleteImage].
  DeleteImageProvider(
    SimilarImage image,
  ) : this._internal(
          () => DeleteImage()..image = image,
          from: deleteImageProvider,
          name: r'deleteImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteImageHash,
          dependencies: DeleteImageFamily._dependencies,
          allTransitiveDependencies:
              DeleteImageFamily._allTransitiveDependencies,
          image: image,
        );

  DeleteImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.image,
  }) : super.internal();

  final SimilarImage image;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant DeleteImage notifier,
  ) {
    return notifier.build(
      image,
    );
  }

  @override
  Override overrideWith(DeleteImage Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeleteImageProvider._internal(
        () => create()..image = image,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        image: image,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DeleteImage, bool> createElement() {
    return _DeleteImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteImageProvider && other.image == image;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, image.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteImageRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `image` of this provider.
  SimilarImage get image;
}

class _DeleteImageProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DeleteImage, bool>
    with DeleteImageRef {
  _DeleteImageProviderElement(super.provider);

  @override
  SimilarImage get image => (origin as DeleteImageProvider).image;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

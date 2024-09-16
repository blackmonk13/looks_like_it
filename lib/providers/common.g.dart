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
String _$selectedImagesHash() => r'24f01833f9783f570f1990399ccb707eb08fe4a5';

/// See also [SelectedImages].
@ProviderFor(SelectedImages)
final selectedImagesProvider =
    AutoDisposeNotifierProvider<SelectedImages, List<SimilarImage>>.internal(
  SelectedImages.new,
  name: r'selectedImagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedImagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedImages = AutoDisposeNotifier<List<SimilarImage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

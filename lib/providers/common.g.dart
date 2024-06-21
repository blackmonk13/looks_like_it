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

String _$similaritiesExecutableHash() =>
    r'01d30bebbae062ccb51da17578a80f0d7681f7ee';

/// See also [SimilaritiesExecutable].
@ProviderFor(SimilaritiesExecutable)
final similaritiesExecutableProvider =
    NotifierProvider<SimilaritiesExecutable, String?>.internal(
  SimilaritiesExecutable.new,
  name: r'similaritiesExecutableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesExecutableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SimilaritiesExecutable = Notifier<String?>;
String _$directoryPickerHash() => r'214eb2c7dbeb4b7744eca5a5c17cbda52c146312';

/// See also [DirectoryPicker].
@ProviderFor(DirectoryPicker)
final directoryPickerProvider =
    NotifierProvider<DirectoryPicker, String?>.internal(
  DirectoryPicker.new,
  name: r'directoryPickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$directoryPickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DirectoryPicker = Notifier<String?>;
String _$similaritiesControllerHash() =>
    r'b59f544c9a44fa81bc9f8b295051aa538430433b';

/// See also [SimilaritiesController].
@ProviderFor(SimilaritiesController)
final similaritiesControllerProvider = AutoDisposeAsyncNotifierProvider<
    SimilaritiesController, Map<SimilarImage, List<SimilarImage>>?>.internal(
  SimilaritiesController.new,
  name: r'similaritiesControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SimilaritiesController
    = AutoDisposeAsyncNotifier<Map<SimilarImage, List<SimilarImage>>?>;
String _$selectionGroupHash() => r'10ee20339765a394c5ad8b14cc38f40c988aca16';

/// See also [SelectionGroup].
@ProviderFor(SelectionGroup)
final selectionGroupProvider = AutoDisposeNotifierProvider<SelectionGroup,
    ({int selectedImage, int selectedSimilarity})>.internal(
  SelectionGroup.new,
  name: r'selectionGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectionGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectionGroup
    = AutoDisposeNotifier<({int selectedImage, int selectedSimilarity})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

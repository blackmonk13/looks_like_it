// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$similaritiesExecutableHash() =>
    r'bf5cd95f0aaf3357097d27759dab9512a5fabf0c';

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
String _$directoryPickerHash() => r'b1b5c1c1e4d49c73c5f35e0a4f4725601ad02751';

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
String _$recentPathsHash() => r'2eb4ca61f6ca7e7bfd9166a6549f5c2a567def8d';

/// See also [RecentPaths].
@ProviderFor(RecentPaths)
final recentPathsProvider =
    AutoDisposeAsyncNotifierProvider<RecentPaths, List<String>>.internal(
  RecentPaths.new,
  name: r'recentPathsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recentPathsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentPaths = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

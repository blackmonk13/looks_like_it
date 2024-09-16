import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/data/similarities_repository.dart';

import 'package:looks_like_it/components/similarities_view.dart';
import 'package:looks_like_it/utils/extensions.dart';

import 'package:looks_like_it/components/scan_loader.dart';

import 'package:looks_like_it/components/selected_images_text.dart';

import 'package:looks_like_it/components/similarities_error_view.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFindSimilarities = ref.watch(
      findSimilaritiesProvider(
        threshold: 1,
        recursive: true,
      ),
    );
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(FluentIcons.arrow_left_24_regular),
        ),
        // title: Text(
        //     "${context.layout.breakpoint.toString()} ${context.layout.width}"),
        actions: const [SelectedImagesText()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
          ),
        ),
      ),
      body: asyncFindSimilarities.when(
        skipLoadingOnReload: true,
        data: (data) {
          // return const ScanLoader();

          return const SimilaritiesView();
        },
        error: (error, stackTrace) {
          return SimilaritiesErrorView(
            error: error,
            stackTrace: stackTrace,
          );
        },
        loading: () {
          return const ScanLoader();
        },
      ),
    );
  }
}

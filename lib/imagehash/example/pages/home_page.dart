import 'dart:async';
import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/imagehash/example/components/folder_navigation_widget.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_view.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/extensions.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanDirectory = ref.watch(directoryPickerProvider);
    final asyncRecentPaths = ref.watch(recentPathsProvider);
    final asyncCompare = ref.watch(comparisonControllerProvider);

    ref.listen(comparisonControllerProvider, (prev, next) {
      final nextValue = next.valueOrNull;
      if (nextValue == null) {
        return;
      }

      if (next.hasError && next.error != null) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: AsyncErrorView(
                error: next.error,
                stackTrace: next.stackTrace,
              ),
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: false
            // ignore: dead_code
            ? null
            : Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Processors: ",
                      children: [
                        TextSpan(
                          text: Platform.numberOfProcessors.toString(),
                        ),
                      ],
                    ),
                    TextSpan(text: "\t" * 5),
                    TextSpan(
                      text: "Breakpoint: ",
                      children: [
                        TextSpan(
                          text: context.layout.breakpoint.name,
                        ),
                      ],
                    ),
                    TextSpan(text: "\t" * 5),
                    TextSpan(
                      text: "Width: ",
                      children: [
                        TextSpan(
                          text: context.layout.width.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        actions: [
          IconButton(
            onPressed: () async {
              await ref
                  .read(imagesProcessingProvider)
                  .requireValue
                  .clearEntries();
            },
            icon: const Icon(
              FluentIcons.database_warning_20_regular,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(
            context.screenWidth,
            28,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                FolderNavigationWidget(
                  initialPath: scanDirectory ?? "",
                  recentLocations: asyncRecentPaths.when(
                    data: (data) {
                      return data;
                    },
                    error: (error, stackTrace) => [],
                    loading: () => [],
                  ),
                  onPathChanged: (value) async {
                    final folderPath = ref
                        .read(
                          directoryPickerProvider.notifier,
                        )
                        .setFolder(value);
                    if (folderPath == null) {
                      return;
                    }
                    ref.invalidate(selectedIndexProvider);
                  },
                  onRecentChanged: (value) async {
                    await Future.wait(
                      value.map(
                        (e) => ref
                            .read(recentPathsProvider.notifier)
                            .setRecentPaths(e),
                      ),
                    );
                  },
                  onRefresh: () async {
                    ref.invalidate(selectedIndexProvider);
                    return ref.refresh(comparisonControllerProvider.future);
                  },
                ),
                asyncCompare.when(
                  skipLoadingOnRefresh: false,
                  data: (data) {
                    return const Divider();
                  },
                  error: (error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // const Expanded(
                          //   child: LinearProgressIndicator(
                          //     color: Colors.red,
                          //     minHeight: 1.0,
                          //   ),
                          // ),
                          const Expanded(
                            child: Divider(
                              color: Colors.red,
                              thickness: 1.0,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: AsyncErrorView(
                                      error: error,
                                      stackTrace: stackTrace,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              FluentIcons.warning_24_regular,
                              color: Colors.red,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Colors.red,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(
                        minHeight: 1.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 4.0),
        child: const Column(
          children: <Widget>[
            Expanded(
              child: SimilaritiesView(),
            ),
          ],
        ),
      ),
    );
  }
}

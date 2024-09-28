import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/delete_btn.dart';
import 'package:looks_like_it/imagehash/example/components/folder_navigation_widget.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_view.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/extensions.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanDirectory = ref.watch(directoryPickerProvider);
    final asyncRecentPaths = ref.watch(recentPathsProvider);

    final selectedIndex = useState<int>(0);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: true
            ? null
            : Text.rich(
                TextSpan(
                  children: [
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
                  onPathChanged: (value) {
                    final folderPath = ref
                        .read(
                          directoryPickerProvider.notifier,
                        )
                        .setFolder(value);
                    if (folderPath == null) {
                      return;
                    }
                  },
                  onRecentChanged: (value) async {
                    final status = await Future.wait(
                      value.map(
                        (e) => ref
                            .read(recentPathsProvider.notifier)
                            .setRecentPaths(e),
                      ),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 4.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SimilaritiesView(
                selectedIndex: selectedIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

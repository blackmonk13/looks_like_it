import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_list_view.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_photo_views.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesView extends HookConsumerWidget {
  const SimilaritiesView({
    super.key,
    required this.selectedIndex,
  });
  final ValueNotifier<int> selectedIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSims = ref.watch(findSimilaritiesProvider);

    return asyncSims.when(
      // skipLoadingOnReload: true,
      data: (similarities) {
        if (similarities.isEmpty) {
          return const Center(
            child: Text("No Similarities"),
          );
        }

        similarities.sort((a, b) => b.similarity.compareTo(a.similarity));

        final filtered = similarities.where((similarity) {
          return File(similarity.image1Path).existsSync() &&
              File(similarity.image2Path).existsSync();
        }).toList();

        return Row(
          children: [
            ...context.layout.value<List<Widget>>(
              xs: [const SizedBox.shrink()],
              sm: context.layout.width < 800
                  ? [const SizedBox.shrink()]
                  : [
                      Flexible(
                        child: SimilaritiesListView(
                          data: filtered,
                          selectedIndex: selectedIndex,
                        ),
                      ),
                      const VerticalDivider(),
                    ],
            ),
            Flexible(
              flex: context.layout.value(
                xs: 4,
                sm: context.layout.width < 900 ? 5 : 3,
              ),
              child: Builder(
                builder: (context) {
                  final item = filtered.elementAt(selectedIndex.value);
                  return SimilaritiesPhotoViews(
                    item: item,
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return Center(
          child: SizedBox(
            width: context.screenWidth * .3,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      },
    );
  }
}

// for /r "C:\Path\To\Your\Folder" %f in (*) do move "%f" "C:\Path\To\Your\Folder"
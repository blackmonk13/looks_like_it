import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_list_view.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_photo_views.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesView extends HookConsumerWidget {
  const SimilaritiesView({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCount = ref.watch(similaritiesCountProvider);
    final pathFilters = ref.watch(pathFiltersProvider);

    final selectedIndex = ref.watch(selectedIndexProvider);

    return asyncCount.when(
      skipLoadingOnRefresh: false,
      // skipLoadingOnReload: true,
      data: (itemCount) {
        if (itemCount == 0) {
          return const Center(
            child: Text("No Similarities"),
          );
        }

        return Row(
          children: [
            ...context.layout.value<List<Widget>>(
              xs: [const SizedBox.shrink()],
              sm: context.layout.width < 800
                  ? [const SizedBox.shrink()]
                  : [
                      Flexible(
                        child: SimilaritiesListView(
                          itemCount: itemCount,
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
              child: SimilaritiesPhotoViews(
                itemCount: itemCount,
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

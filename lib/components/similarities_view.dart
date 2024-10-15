import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/components/empty_similarities_view.dart';
import 'package:looks_like_it/components/similarities_list_view.dart';
import 'package:looks_like_it/components/similarities_photo_views.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesView extends HookConsumerWidget {
  const SimilaritiesView({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCount = ref.watch(similaritiesCountProvider);
    // return const EmptySimilaritiesView();
    return asyncCount.when(
      skipLoadingOnRefresh: false,
      // skipLoadingOnReload: true,
      data: (itemCount) {
        if (itemCount == 0) {
          return const EmptySimilaritiesView();
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
                      VerticalDivider(
                        thickness: .5,
                        color: context.colorScheme.outline.withOpacity(.5),
                        width: 0.5,
                      ),
                    ],
            ),
            Flexible(
              flex: context.layout.value(
                xs: 6,
                sm: context.layout.width < 900 ? 6 : 3,
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
